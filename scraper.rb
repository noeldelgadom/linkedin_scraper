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

def extract_jobs(browser)
  job_page = 'https://www.linkedin.com/jobs/search/?location=Mexico%20City%20Area%2C%20Mexico&locationId=mx%3A5921'
  browser.goto(job_page)

  jobs = []
  browser.ul(class: 'jobs-search-results__list').children.each do |li|
    li.click
    sleep(1)

    if browser.div(class: 'jobs-poster').exists?  # Not all job posts have job-posters, hence this if statement
      puts 'poster exists'
      job = {}

      job[:job_name]          = browser.a(class: 'jobs-details-top-card__job-title-link').inner_text
      job[:job_url]           = browser.a(class: 'jobs-details-top-card__job-title-link').href

      job[:company_name]      = browser.a(class: 'jobs-details-top-card__company-url').inner_text
      job[:company_url]       = browser.a(class: 'jobs-details-top-card__company-url').href

      job[:job_poster_name]   = browser.p(class: 'jobs-poster__name').inner_text
      job[:job_poster_url]    = browser.div(class: 'jobs-poster__wrapper').a.href
      
      jobs << job
    else
      puts 'poster doesnt exist'
    end
  end

  # Need to add pagination. As of now only 1st page is processed

  byebug
  
  return jobs
end

def scraper
  browser = Watir::Browser.new
  
  browser = login(browser)

  jobs = extract_jobs(browser)
end

scraper
