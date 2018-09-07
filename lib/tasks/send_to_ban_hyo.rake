require 'line/bot'

namespace :send_to_ban_hyo do
  def create_new_tobanhyo
    # 最新の当番表を取得し、コピーする
    new_tobanhyo = Tobanhyo.where(start_of_period: Tobanhyo.maximum(:start_of_period)).map(&:dup)
    # 固定の役割かどうかでグルーピングする
    new_tobanhyo_group = new_tobanhyo.group_by(&:fixed)
    # 固定でない当番表のrole_idを取得し、rotateさせる
    new_roles = new_tobanhyo_group[false].map(&:role_id).rotate
    # 固定でない当番表の日付を今日にし、保存する
    new_tobanhyo_group[false].zip(new_roles).each do |hyo, new_role_id|
      hyo.start_of_period = Time.zone.today.strftime('%Y/%m/%d')
      hyo.role_id = new_role_id
      hyo.save!
    end
    # 固定の当番表の日付を今日にし、保存する
    new_tobanhyo_group[true].each do |hyo|
      hyo.start_of_period = Time.zone.today.strftime('%Y/%m/%d')
      hyo.save!
    end
  end

  def create_tobanhyo_msg
    # （暫定対処）定数部分は今後DBに入れてカスタムできるようにする
    sunday = "今週の掃除当番です！\n掃除が完了したらこちらに完了した旨を投稿してください！
[#{Time.zone.today.strftime('%Y/%m/%d')} 〜 #{Time.zone.today.since(7.days).strftime('%Y/%m/%d')}]\n\n"
    saturday = "今週の掃除は終わりましたか？\n終わっていたらその旨をお知らせください！\n\n"
    msg = Time.zone.today.sunday? ? sunday : saturday
    # ここまで暫定対処
    # 最新の日付の当番表を取得する
    toban_list = Tobanhyo.where(start_of_period: Tobanhyo.maximum(:start_of_period))
    toban_group = toban_list.group_by(&:fixed)
    toban_group[false].each do |hyo|
      msg << "#{hyo.room.name}: #{hyo.role.name}\n"
    end
    msg << "---\n"
    toban_group[true].each do |hyo|
      msg << "#{hyo.room.name}: #{hyo.role.name}\n"
    end
    msg
  end

  def send_msg
    # 日曜日、且つその日の日付のレコードがなかったら当番表を作成する
    create_new_tobanhyo if Time.zone.today.sunday? && Tobanhyo.where(start_of_period: Time.zone.today).empty?
    message = {
      type: 'text',
      text: create_tobanhyo_msg
    }
    send_line(message)
  end

  def send_line(message)
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_ACCESS_TOKEN"]
    }
    response = client.push_message(ENV["LINE_GROUP_ID"], message)
    p response
  end

  desc "send_to_ban_hyo"
  task tobanhyo: :environment do
    # 日曜日は新規当番表の作成（ローテーション）、土曜日はリマインドメッセージを送信する処理を流す
    if Time.zone.today.sunday? || Time.zone.today.saturday?
    send_msg
    end
  end
end
