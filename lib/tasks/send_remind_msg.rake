require 'net/http'
require 'uri'

namespace :send_remind_msg do
  desc "send_remind_msg"
  task tobanhyo: :environment do
    if !Time.zone.today.thursday? || !Time.zone.today.saturday?
      Net::HTTP.post_form(URI.parse("#{ENV["SEND_REMIND_MSG"]}"), {'q'=>'ruby', 'max'=>'50'})
    end
  end
end
