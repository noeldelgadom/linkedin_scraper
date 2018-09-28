def extract_jobs(browser_one, browser_two)
  job_page = 'https://www.linkedin.com/jobs/search/?location=Mexico%20City%20Area%2C%20Mexico&locationId=mx%3A5921'
  browser_one.goto(job_page)

  jobs = []
  browser_one.ul(class: 'jobs-search-results__list').children.each do |li|
    li.click
    sleep(1)      # The click is to fast. The sleep is there to let the javascript load the data.

    if browser_one.div(class: 'jobs-poster').exists?  # Not all job posts have job-posters, hence this if statement
      puts 'poster exists'
      job = {}

      job[:job_name]          = browser_one.a(class: 'jobs-details-top-card__job-title-link').inner_text
      job[:job_url]           = browser_one.a(class: 'jobs-details-top-card__job-title-link').href

      job[:company_name]      = browser_one.a(class: 'jobs-details-top-card__company-url').inner_text
      job[:company_url]       = browser_one.a(class: 'jobs-details-top-card__company-url').href

      job[:contact_name]      = browser_one.p(class: 'jobs-poster__name').inner_text
      job[:contact_url]       = browser_one.div(class: 'jobs-poster__wrapper').exists? ? # The classes on this div change depending on whether it is the first post or not.
                                  browser_one.div(class: 'jobs-poster__wrapper').a.href :
                                  browser_one.div(class: 'jobs-poster--is-expanded').a.href


      # Use Browser Two to extract Company Industry
      browser_two.goto(job[:company_url])
      job[:company_industry] = browser_two.span(class: 'company-industries').inner_text

      # Use Browser Two to extract Contact Email
      browser_two.goto(job[:contact_url] + 'detail/contact-info/')
      sleep(1)
      if browser_two.section(class: 'ci-email').exists?
        puts 'email exists'
        job[:contact_email] = browser_two.section(class: 'ci-email').a.inner_text
      else
        puts 'email doesnt exist'
        job[:contact_email] = ''
      end
      
      jobs << job
    else
      puts 'poster doesnt exist'
    end
  end

  # Need to add pagination. As of now only 1st page is processed
  
  return jobs
end
