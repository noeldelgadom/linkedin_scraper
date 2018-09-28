require 'nokogiri'
require 'httparty'
require 'byebug'
require 'webdrivers'
require 'watir'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'.freeze
CREDENTIALS_PATH = 'credentials.json'.freeze
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

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
    sleep(1)      # The click is to fast. The sleep is there to let the javascript load the data.

    if browser.div(class: 'jobs-poster').exists?  # Not all job posts have job-posters, hence this if statement
      puts 'poster exists'
      job = {}

      job[:job_name]          = browser.a(class: 'jobs-details-top-card__job-title-link').inner_text
      job[:job_url]           = browser.a(class: 'jobs-details-top-card__job-title-link').href

      job[:company_name]      = browser.a(class: 'jobs-details-top-card__company-url').inner_text
      job[:company_url]       = browser.a(class: 'jobs-details-top-card__company-url').href

      job[:contact_name]      = browser.p(class: 'jobs-poster__name').inner_text
      job[:contact_url]       = browser.div(class: 'jobs-poster__wrapper').exists? ? # The classes on this div change depending on whether it is the first post or not.
                                  browser.div(class: 'jobs-poster__wrapper').a.href :
                                  browser.div(class: 'jobs-poster--is-expanded').a.href
      
      jobs << job
    else
      puts 'poster doesnt exist'
    end
  end

  # Need to add pagination. As of now only 1st page is processed
  
  return jobs
end

def get_company_industries_and_emails(jobs, browser)

  jobs.each do |job|
    browser.goto(job[:company_url])
    job[:company_industry] = browser.span(class: 'company-industries').inner_text

    browser.goto(job[:contact_url] + 'detail/contact-info/')
    sleep(1) # Need to wait for the popup to open. Almost no one has public emails though. 
    if browser.section(class: 'ci-email').exists?
      puts 'email exists'
      job[:contact_email] = browser.section(class: 'ci-email').a.inner_text
    else
      puts 'email doesnt exist'
      job[:contact_email] = ''
    end
  end

  return jobs
end

def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

def scraper
  # browser = Watir::Browser.new
  
  # browser = login(browser)

  # # jobs = extract_jobs(browser)

  # jobs_with_industries_and_emails = get_company_industries_and_emails(jobs, browser)

  jobs_with_industries_and_emails = [
    {
      :job_name => "Print, POS & Promotional Merchandise - Account/Project Managers",
      :job_url => "https://www.linkedin.com/jobs/view/867430578/?refId=0b7e611c-6007-4720-9f3c-581c766f8609&trk=flagship3_search_srp_jobs",
      :company_name => "Adare International",
      :company_url => "https://www.linkedin.com/company/896814/life/",
      :contact_name => "Noel Delgado",
      :contact_url => "https://www.linkedin.com/in/noeldelgadom/",
      :company_industry => "Marketing and Advertising",
      :contact_email => "noeled@umich.edu"
    }, {
      :job_name => "Ejecutivo comercial (consultoria, outsourcing)",
      :job_url => "https://www.linkedin.com/jobs/view/868840306/?refId=0b7e611c-6007-4720-9f3c-581c766f8609&trk=flagship3_search_srp_jobs",
      :company_name => "Experis",
      :company_url => "https://www.linkedin.com/company/2203697/life/",
      :contact_name => "Néstor González",
      :contact_url => "https://www.linkedin.com/in/n%C3%A9stor-gonz%C3%A1lez-bb209696/",
      :company_industry => "Staffing and Recruiting",
      :contact_email => ""
    }, {
      :job_name => "Soporte Tecnico Jr.",
      :job_url => "https://www.linkedin.com/jobs/view/873786961/?refId=0b7e611c-6007-4720-9f3c-581c766f8609&trk=flagship3_search_srp_jobs",
      :company_name => "Experis/Manpower Group",
      :company_url => "https://www.linkedin.com/company/1233852/life/",
      :contact_name => "Michelle Diaz Castañeda",
      :contact_url => "https://www.linkedin.com/in/michelle-diaz-casta%C3%B1eda-6aa8b8b0/",
      :company_industry => "Staffing and Recruiting",
      :contact_email => ""
    }, {
      :job_name => "Fall Protection Sr Account Manager",
      :job_url => "https://www.linkedin.com/jobs/view/885602251/?refId=0b7e611c-6007-4720-9f3c-581c766f8609&trk=flagship3_search_srp_jobs",
      :company_name => "Honeywell",
      :company_url => "https://www.linkedin.com/company/1344/life/",
      :contact_name => "Sergio Chavolla",
      :contact_url => "https://www.linkedin.com/in/sergio-chavolla-1770a44/",
      :company_industry => "Electrical/Electronic Manufacturing",
      :contact_email => ""
    }, {
      :job_name => "Legal Manager",
      :job_url => "https://www.linkedin.com/jobs/view/877420060/?refId=0b7e611c-6007-4720-9f3c-581c766f8609&trk=flagship3_search_srp_jobs",
      :company_name => "Eutelsat Americas",
      :company_url => "https://www.linkedin.com/company/29356/life/",
      :contact_name => "Fabiola Dávila Enriquez",
      :contact_url => "https://www.linkedin.com/in/fabiola-d%C3%A1vila-enriquez-499591117/",
      :company_industry => "Telecommunications",
      :contact_email => ""
    }, {
      :job_name => "Beauty Director, Consumer Insights",
      :job_url => "https://www.linkedin.com/jobs/view/883083442/?refId=0b7e611c-6007-4720-9f3c-581c766f8609&trk=flagship3_search_srp_jobs",
      :company_name => "The NPD Group",
      :company_url => "https://www.linkedin.com/company/166393/life/",
      :contact_name => "Lizette Medina, RACR Certified",
      :contact_url => "https://www.linkedin.com/in/lizette-medina-racr-certified-677b9741/",
      :company_industry => "Market Research",
      :contact_email => ""
    }, {
      :job_name => "Solution Account Manager",
      :job_url => "https://www.linkedin.com/jobs/view/856598206/?refId=0b7e611c-6007-4720-9f3c-581c766f8609&trk=flagship3_search_srp_jobs",
      :company_name => "Grupo Novandi",
      :company_url => "https://www.linkedin.com/company/3751050/life/",
      :contact_name => "Reclutador Novandi",
      :contact_url => "https://www.linkedin.com/in/reclutadornovandi/",
      :company_industry => "Management Consulting",
      :contact_email => ""
    }]

  byebug

  # Google Spreadsheet part
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize

  spreadsheet_id = '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms'
  range = 'Class Data!A2:E'
  response = service.get_spreadsheet_values(spreadsheet_id, range)
  puts 'Name, Major:'
  puts 'No data found.' if response.values.empty?
  
  byebug
  
end

scraper
