class TobanhyosController < ApplicationController
  require 'line/bot'
  # apiからのアクセスがあるため以下のアクションを例外に設定
  protect_from_forgery except: [:send_tobanhyo, :send_remind_msg]

  def create_new_tobanhyo
    new_tobanhyo = Tobanhyo.where(start_of_period: Time.zone.today.ago(7.days)).map(&:dup)
    new_tobanhyo_group = new_tobanhyo.group_by(&:fixed)
    new_roles = new_tobanhyo_group[false].map(&:role_id).rotate
    new_tobanhyo_group[false].zip(new_roles).each do |hyo, new_role_id|
      hyo.start_of_period = Time.zone.today.strftime('%Y/%m/%d')
      hyo.role_id = new_role_id
      hyo.save!
    end
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
    toban_list = Tobanhyo.where(start_of_period: Time.zone.today)
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

  def create_remind_msg
    duty, toban_id = case Time.zone.today.strftime("%a")
                     when "Sun" then ["資源ごみ", 6]
                     when "Mon" then ["プラスチック", 6]
                     when "Wed" then ["燃えないゴミ", 6]
                     when "Tue","Fri" then ["燃えるゴミ", 2]
                     end
    toban = Tobanhyo.where(role_id: toban_id).order(:start_of_period).last
    msg = "明日は #{duty} の日です！\nよろしくお願いします！\n\n#{toban.room.name}: #{toban.role.name}"
    msg
  end

  def send_msg
    create_new_tobanhyo if Time.zone.today.sunday?
    message = {
      type: 'text',
      text: create_tobanhyo_msg
    }
    send_line(message)
  end
  # 暫定対応
  def send_remind_msg
    message = {
      type: 'text',
      text: create_remind_msg
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
end
