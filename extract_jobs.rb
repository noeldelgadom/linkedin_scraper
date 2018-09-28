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
