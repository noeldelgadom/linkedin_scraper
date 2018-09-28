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
  #Open Two Browsers. One scans the jobs, the other the companies and contacts
  browser_one = Watir::Browser.new
  browser_two = Watir::Browser.new
  browser_one = login(browser_one)
  browser_two = login(browser_two)

  jobs = extract_jobs(browser_one, browser_two)       # Extracts real data from LinkedIn
  # jobs = easy_load_jobs                             # Extracts fake data from easy_load_jobs.rb

  google_array = []
  jobs.each {|job| google_array << job.values }

  # Google Spreadsheet part
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize

  spreadsheet_id = '1R3sEe4NENwr9Su7hda7be9BZCGcCDTZ03lurXp0E2hk'
  range = 'Sheet1!A2:E'
  value_range = Google::Apis::SheetsV4::ValueRange.new(values: google_array)
  result = service.append_spreadsheet_value(spreadsheet_id,
                                            range,
                                            value_range,
                                            value_input_option: "USER_ENTERED")
  
  byebug
  
end

scraper
