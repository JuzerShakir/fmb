Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.args << "--headless"
  options.args << "--disable-gpu"
  # downloads pdf by default, so setting invalid directory will discard it
  options.add_preference("download.default_directory", "/path/to/invalid/directory")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.javascript_driver = :headless_chrome
