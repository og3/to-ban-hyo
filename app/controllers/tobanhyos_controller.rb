class TobanhyosController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:send_line_msg]

  def rotate
    tobanhyo = Tobanhyo.where(fixed: nil)
    new_roles = tobanhyo.map{ |hyo| hyo.role_id }.rotate!
    tobanhyo.zip(new_roles).each do |hyo, new_role_id|
      hyo.role_id = new_role_id
      hyo.save!
    end
  end

  def create_line_msg
    tobanhyo = Tobanhyo.all
    msg = "今週の掃除当番です！\n"
    msg << "[#{Time.now.strftime('%Y/%m/%d')} 〜 #{Time.now.since(7.days).strftime('%Y/%m/%d')}]\n\n"
    msg << "掃除が完了したらこちらに完了した旨を投稿してください！\n\n"
    tobanhyo.each do |hyo|
      msg << "#{hyo.room.name}: #{hyo.role.name}\n"
    end
    msg
  end

  def send_line_msg
    rotate
    message = {
      type: 'text',
      text: create_line_msg
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_ACCESS_TOKEN"]
    }
    response = client.push_message(ENV["LINE_GROUP_ID"], message)
    p response
  end
end
