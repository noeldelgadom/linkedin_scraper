def append_to_google_sheet(job, service)

  response = service.get_spreadsheet_values(SPREADSHEET_ID, CONTACT_RANGE)

  unless response.values.include? [job[:contact_url]]
    service.append_spreadsheet_value( SPREADSHEET_ID,
                                      ALL_RANGE,
                                      Google::Apis::SheetsV4::ValueRange.new(values: [job.values]),
                                      value_input_option: "USER_ENTERED")
  end
end
