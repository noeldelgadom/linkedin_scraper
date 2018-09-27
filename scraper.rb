require 'nokogiri'
require 'httparty'
require 'byebug'
require 'webdrivers'
require 'watir'

def sign_in
  url = "https://www.linkedin.com"
  browser = Watir::Browser.new
  browser.goto(url)
  browser.text_field(:class, "login-email").set("John Doe")
  browser.text_field(:class, "login-password").set("p@ssw0rd")
  browser.button(:id, "login-submit").click

  byebug
end
def scraper
  # url           = "https://www.linkedin.com/jobs/search?keywords=&location=Mexico%20City%20Area%2C%20Mexico&locationId=mx:5921"
  url           = "https://www.linkedin.com"

  browser = Watir::Browser.new
  browser.goto(url)
  search_results = browser.element(css: "ul.search-results")
  search_results.children.each do |job_listing|
    puts job_listing
    company = {
      name: job_listing.children.last.children[1].children.first.children.first.inner_text,
      link: job_listing.children.last.children[1].children.first.children.first.href
    }
    byebug
  end
end


sign_in
# scraper
