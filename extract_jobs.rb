def extract_jobs(browser_one, browser_two, service)
  job_page = 'https://www.linkedin.com/jobs/search/?location=Mexico%20City%20Area%2C%20Mexico&locationId=mx%3A5921'
  browser_one.goto(job_page)

  continue_scan = true
  while continue_scan

    # Loop through each Job Post with Browser One
    browser_one.ul(class: 'jobs-search-results__list').children.each do |li|
      li.click
      sleep(1)

      # Not all job posts have job-posters, hence this if statement
      if browser_one.div(class: 'jobs-poster').exists?
        puts 'poster exists'
        job = {}

        # Use Browswer One to extract job, company and contact
        job[:job_name]          = browser_one.a(class: 'jobs-details-top-card__job-title-link').inner_text
        job[:job_url]           = browser_one.a(class: 'jobs-details-top-card__job-title-link').href
        job[:contact_name]      = browser_one.p(class: 'jobs-poster__name').inner_text
        job[:contact_url]       = browser_one.div(class: 'jobs-poster__wrapper').exists? ? # The classes on this div change depending on whether it is the first post or not.
                                    browser_one.div(class: 'jobs-poster__wrapper').a.href :
                                    browser_one.div(class: 'jobs-poster--is-expanded').a.href

        # Use Browser Two to extract Company
        if browser_one.a(class: 'jobs-details-top-card__company-url').exists?
          job[:company_name]      = browser_one.a(class: 'jobs-details-top-card__company-url').inner_text
          job[:company_url]       = browser_one.a(class: 'jobs-details-top-card__company-url').href

          browser_two.goto(job[:company_url])
          sleep(0.4)
          job[:company_url]       = browser_two.url   # This line is needed for companies that have non-ID URLs
          job[:company_industry]  = browser_two.span(class: 'company-industries').inner_text
        else
          byebug
          job[:company_name]      = browser_one.h3(class: 'jobs-details-top-card__company-info').inner_text[12..-1]
          job[:company_url]       = ''
          job[:company_industry]  = ''
        end

        # Use Browser Two to extract Contact Email (if it exists)
        browser_two.goto(job[:contact_url] + 'detail/contact-info/')
        sleep(1)
        job[:contact_email] = browser_two.section(class: 'ci-email').exists? ?
                                browser_two.section(class: 'ci-email').a.inner_text : ''

        # Paste to Google Sheet
        append_to_google_sheet(job, service)
      else
        puts 'poster doesnt exist'
      end
    end

    puts '-'
    puts 'Do you want to scan more? (y/n): '
    continue_scan = gets.chomp == 'y'
    browser_one.ol(class: 'results-paginator').li.ol.li(class: 'active').next_sibling.click
  end
end
