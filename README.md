# LinkedIn Scraper

This program scrapes LinkedIn jobs and enters the data into a Google Sheet.
The information gathered includes job title, company and job poster.

## Installation

1. Go to the directory where you want the project
2. `$ git clone https://github.com/noeldelgadom/linkedin_scraper.git`
3. `$ cd linkedin_scraper`
4. `$ bundle`
5. `$ ruby scraper.rb`

## Google Sheets

Accessing the Google Spreadsheet requires my permission.

## Other

* Jobs searched are limited to the Mexico City area.
* About 25% of job postings have the contact information visible. Hence, more jobs are scanned relative to the contact information retrieved.
* Contact information always includes profile link, but rarely includes email. This is because most people hide it with privacy settings.
* Two Watir browsers instances are used. One of them scrapes the jobs, the other scrapes the company and contact info.
* Login is done with a recently created 'fake' account under the name Tom Brady. This account is very empty so that job postings are not targeted in any way. If you use a real account, only relevant job postings to that account show up. 
