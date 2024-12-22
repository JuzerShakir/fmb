Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.args << "--headless"
  options.args << "--disable-gpu"
  # PDF downloads by default; invalid directory blocks it
  options.add_preference("download.default_directory", "/path/to/invalid/directory")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.javascript_driver = :headless_chrome
