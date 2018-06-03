class TobanhyosController < ApplicationController
  require 'line/bot'
  require 'date'
  # apiからのアクセスがあるため以下のアクションを例外に設定
  protect_from_forgery except: [:send_tobanhyo, :send_remind_msg]

  def create_new_hyo
    tobanhyo = Tobanhyo.where(start_of_period: Time.now.ago(7.days))
    new_tobanhyo = tobanhyo.map{ |hyo| hyo.dup }
    new_tobanhyo.each do |hyo|
      hyo.start_of_period = Time.now.strftime('%Y/%m/%d')
      hyo.save!
    end
  end

  def rotate
    tobanhyo = Tobanhyo.where(start_of_period: Time.now.strftime('%Y/%m/%d')).where(fixed: 0)
    new_roles = tobanhyo.map{ |hyo| hyo.role_id }.rotate!
    tobanhyo.zip(new_roles).each do |hyo, new_role_id|
      hyo.role_id = new_role_id
      hyo.save!
    end
  end

  def create_line_msg
    tobanhyo = Tobanhyo.where(start_of_period: Time.now.strftime('%Y/%m/%d')).where(fixed: 0)
    fixed = Tobanhyo.where(start_of_period: Time.now.strftime('%Y/%m/%d')).where(fixed: 1)
    msg = "今週の掃除当番です！\n掃除が完了したらこちらに完了した旨を投稿してください！
[#{Time.now.strftime('%Y/%m/%d')} 〜 #{Time.now.since(7.days).strftime('%Y/%m/%d')}]\n\n" if Date.today.sunday?
    tobanhyo.each do |hyo|
      msg << "#{hyo.room.name}: #{hyo.role.name}\n"
    end
    msg << "---\n"
    fixed.each do |hyo|
      msg << "#{hyo.room.name}: #{hyo.role.name}\n"
    end
    msg
  end

  def send_tobanhyo
    create_new_hyo
    rotate
    message = {
      type: 'text',
      text: create_line_msg
    }
    send_line(message)
  end

  def send_remind_msg
    message = {
      type: 'text',
      text: "今週の掃除は終わりましたか？\n終わっていたらその旨をお知らせください！\n\n#{create_line_msg}"
    }
    send_line(message)
  end

private
  def send_line(message)
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_ACCESS_TOKEN"]
    }
    response = client.push_message(ENV["LINE_GROUP_ID"], message)
    p response
  end
end
