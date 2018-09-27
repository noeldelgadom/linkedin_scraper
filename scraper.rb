require 'nokogiri'
require 'httparty'
require 'byebug'
require 'webdrivers'
require 'watir'


def login(browser)
  url = "https://www.linkedin.com"
  browser.goto(url)

  puts '---'
  puts 'Login to LinkedIn'
  puts 'Email: '
  email = 'noeldelgado89@hotmail.com'
  # email = gets.chomp
  puts 'Password: '
  password = 'notQB12'
  # password = STDIN.noecho(&:gets).chomp

  browser.text_field(:class, "login-email").set(email)
  browser.text_field(:class, "login-password").set(password)
  browser.button(:id, "login-submit").click
  return browser
end

def extract_companies(browser)
  companies = []

  company = {}
  company[:name] = "sample company"
  company[:link] = "sample link"
  companies << company

  job_page = 'https://www.linkedin.com/jobs/search/?location=Mexico%20City%20Area%2C%20Mexico&locationId=mx%3A5921'

  browser.goto(job_page)

  byebug

  return companies
end

def scraper
  browser = Watir::Browser.new
  
  browser = login(browser)

  companies = extract_companies(browser)
end

scraper
