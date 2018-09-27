require 'nokogiri'
require 'httparty'
require 'byebug'
require 'webdrivers'
require 'watir'

def scraper
  url = "https://www.linkedin.com"
  browser = Watir::Browser.new
  browser.goto(url)

  puts '---'
  puts 'Login to LinkedIn'
  puts 'Email: '
  email = gets.chomp
  puts 'Password: '
  password = STDIN.noecho(&:gets).chomp

  browser.text_field(:class, "login-email").set(email)
  browser.text_field(:class, "login-password").set(password)
  browser.button(:id, "login-submit").click

  byebug
end

scraper
