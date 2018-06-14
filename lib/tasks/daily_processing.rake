require 'net/http'
require 'uri'

namespace :daily_processing do
  desc "daily_processing"
  task tobanhyo: :environment do
    if Time.zone.today.sunday? || Time.zone.today.saturday?
      Net::HTTP.post_form(URI.parse("#{ENV["SEND_TOBANHYO"]}"), {'q'=>'ruby', 'max'=>'50'})
    end
  end
end
