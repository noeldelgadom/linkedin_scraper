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
  job_page = 'https://www.linkedin.com/jobs/search/?location=Mexico%20City%20Area%2C%20Mexico&locationId=mx%3A5921'
  browser.goto(job_page)

  companies = []
  browser.ul(class: 'jobs-search-results__list').children.each do |li|
    li.click
    company = {}
    company[:name] = browser.a(class: 'jobs-details-top-card__company-url').inner_text
    company[:link] = browser.a(class: 'jobs-details-top-card__company-url').href
    companies << company
  end

  # Need to add pagination. As of now only 1st page is processed

  byebug

  return companies
end

def scraper
  browser = Watir::Browser.new
  
  browser = login(browser)

  companies = extract_companies(browser)
end

scraper
