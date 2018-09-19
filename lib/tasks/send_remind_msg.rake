require 'line/bot'

namespace :send_remind_msg do
  def create_remind_msg
    duty, toban_id = case Time.zone.today.strftime("%a")
                     when "Sun" then ["資源ごみ", 6]
                     when "Mon" then ["プラスチック", 6]
                     when "Wed" then ["燃えないゴミ", 6]
                     when "Tue", "Fri" then ["燃えるゴミ", 2]
                     end
    toban = Tobanhyo.where(role_id: toban_id).order(:start_of_period).last
    msg = "明日は #{duty} の日です！\nよろしくお願いします！\n\n#{toban.room.name}: #{toban.role.name}\n\n備考：#{toban.role.memo}"
    msg
  end

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

  desc "send_remind_msg"
  task tobanhyo: :environment do
    if !Time.zone.today.thursday? || !Time.zone.today.saturday?
      send_remind_msg
    end
  end
end
