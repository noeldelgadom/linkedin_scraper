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
