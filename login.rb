def login(browser_one, browser_two)
  puts '---'
  puts 'Logging in to LinkedIn'
  # puts 'Email: '
  # email = gets.chomp
  # puts 'Password: '
  # password = STDIN.noecho(&:gets).chomp

  email     = 'noeldelgado89@hotmail.com'
  password  = 'notQB12'

  url = "https://www.linkedin.com"
  [browser_one, browser_two].each_with_index do |browser, i|
    puts 'Loging in with Browser ' + (i + 1).to_s + ' ...'
    browser.goto(url)
    browser.text_field(class: "login-email").set(email)
    browser.text_field(class: "login-password").set(password)
    browser.button(id: "login-submit").click
  end
  puts 'Logged in with both Browsers'
end
