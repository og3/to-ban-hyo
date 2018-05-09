require 'net/http'
require 'uri'

namespace :periodic_execution do
  desc "periodic_execution"
  task tobanhyo: :environment do
    Net::HTTP.post_form(URI.parse("#{ENV["LINE_POST_URL"]}"), {'q'=>'ruby', 'max'=>'50'})
  end
end
