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
  browser = Watir::Browser.new
  
  browser = login(browser)

  # # jobs = extract_jobs(browser)

  # jobs_with_industries_and_emails = get_company_industries_and_emails(jobs, browser)
  jobs_with_industries_and_emails = easy_load_jobs

  google_array = []
  jobs_with_industries_and_emails.each {|job| google_array << job.values }

  # Google Spreadsheet part
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize

  spreadsheet_id = '1R3sEe4NENwr9Su7hda7be9BZCGcCDTZ03lurXp0E2hk'
  range = 'Sheet1!A2:E'
  # response = service.get_spreadsheet_values(spreadsheet_id, range)
  # puts 'Name, Major:'
  # puts 'No data found.' if response.values.empty?

  value_range = Google::Apis::SheetsV4::ValueRange.new(values: google_array)
  result = service.append_spreadsheet_value(spreadsheet_id,
                                          range,
                                          value_range,
                                          value_input_option: "USER_ENTERED")
  
  byebug
  
end

scraper
