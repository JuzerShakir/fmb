Capybara.register_driver :headless_firefox do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(
    "moz:firefoxOptions": {args: %w[-headless -disable-gpu]}
  )
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: capabilities)
end

Capybara.javascript_driver = :headless_firefox
