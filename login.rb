def login(browser_one, browser_two)
  puts '---'
  puts 'Login to LinkedIn'
  puts 'Email: '
  email = 'noeldelgado89@hotmail.com'
  # email = gets.chomp
  puts 'Password: '
  password = 'notQB12'
  # password = STDIN.noecho(&:gets).chomp

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
