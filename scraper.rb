require 'byebug'
require 'webdrivers'
require 'watir'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

require_relative 'google_sheets_constants.rb'
require_relative 'login.rb'
require_relative 'extract_jobs.rb'
require_relative 'authorize.rb'
require_relative 'easy_load_jobs.rb'

def scraper
  # Initiate Google Spreadsheets
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize

  # Open Two Browsers. One scans the jobs, the other the companies and contacts
  browser_one = Watir::Browser.new
  browser_two = Watir::Browser.new
  login(browser_one, browser_two)

  extract_jobs(browser_one, browser_two, service)       # Extracts real data from LinkedIn
  # jobs = easy_load_jobs                             # Extracts fake data from easy_load_jobs.rb
  
  byebug
  
end

scraper
