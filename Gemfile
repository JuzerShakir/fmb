source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.3.6"

gem "rails", "~> 7.2.2"

gem "active_record_union"
gem "bcrypt", "~> 3.1.20"
gem "bootsnap", require: false
gem "cancancan", "~> 3.6.1"
gem "cssbundling-rails"
gem "faker", "~> 3.5.1"
gem "friendly_id", "~> 5.5.1"
gem "humanize", "~> 3.1.0"
gem "jbuilder"
gem "jsbundling-rails"
gem "pagy", "~> 9.3.3"
gem "pg", "~> 1.5.4"
gem "prawn", "~> 2.5.0"
gem "prawn-table", "~> 0.2.2"
gem "propshaft"
gem "puma", "~> 6.5.0"
gem "rails-i18n", "~> 7.0.8"
gem "ransack", "~> 4.2.1"
gem "redis", "~> 5.3.0"
gem "rolify", "~> 6.0.1"
gem "simple_form", "~> 5.3.0"
gem "stimulus-rails"
gem "turbo-rails", "~> 2.0.11"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "validates_email_format_of", "~> 1.8.2"
gem "validates_timeliness", "~> 7.0.0"

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "factory_bot_rails", "~> 6.4.0"
  gem "rspec-rails", "~> 7.1.0"
  gem "rubocop-rails", "2.27.0", require: false
  gem "rubocop-rspec_rails", require: false
  gem "rubocop-factory_bot", "~> 2.26", ">= 2.26.1", require: false
  gem "rubocop-capybara", "~> 2.21", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rspec", require: false
  gem "standard", require: false
end

group :development do
  gem "dockerfile-rails", ">= 1.6"
  gem "erb_lint", require: false
  gem "web-console"
end

group :test do
  gem "capybara", "~> 3.40.0"
  gem "rack_session_access"
  gem "rails-controller-testing", "~> 1.0.5"
  gem "selenium-webdriver", "~> 4.27.0"
  gem "shoulda-callback-matchers", "~> 1.1.4"
  gem "shoulda-matchers", "~> 6.4.0"
  gem "simplecov", require: false
end

group :production do
  gem "sentry-rails", "~> 5.22.0"
  gem "sentry-ruby", "~> 5.22.0"
end
