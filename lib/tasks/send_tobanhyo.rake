require 'net/http'
require 'uri'

namespace :send_tobanhyo do
  desc "send_tobanhyo"
  task tobanhyo: :environment do
    Net::HTTP.post_form(URI.parse("#{ENV["SEND_TOBANHYO"]}"), {'q'=>'ruby', 'max'=>'50'})
  end
end
