require 'net/http'
require 'uri'
require 'date'

namespace :daily_processing do
  desc "daily_processing"
  task tobanhyo: :environment do
    if Date.today.sunday?
      Net::HTTP.post_form(URI.parse("#{ENV["SEND_TOBANHYO"]}"), {'q'=>'ruby', 'max'=>'50'})
    elsif Date.today.saturday?
      Net::HTTP.post_form(URI.parse("#{ENV["SEND_REMIND_MSG"]}"), {'q'=>'ruby', 'max'=>'50'})
    end
  end
end
