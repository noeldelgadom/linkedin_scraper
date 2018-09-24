require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
  url           = "https://www.linkedin.com/jobs/search?keywords=&location=Mexico%20City%20Area%2C%20Mexico&locationId=mx:5921"
	unparsed_page = HTTParty.get(url)
  parsed_page   = Nokogiri::HTML(unparsed_page)

  byebug
end

scraper
