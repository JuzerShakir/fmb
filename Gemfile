source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.3.0"

gem "rails", "~> 7.1.3"

gem "active_record_union"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "cancancan", "~> 3.5.0"
gem "cssbundling-rails"
gem "faker", "~> 3.2.2"
gem "friendly_id", "~> 5.5.1"
gem "humanize", "~> 2.5.1"
gem "jbuilder"
gem "jsbundling-rails"
gem "pagy", "~> 6.2.0"
gem "pg", "~> 1.5.4"
gem "prawn", "~> 2.4.0"
gem "prawn-table", "~> 0.2.2"
gem "propshaft"
gem "puma", "~> 6.4.2"
gem "rails-i18n", "~> 7.0.8"
gem "ransack", "~> 4.1.1"
gem "redis", "~> 5.0.8"
gem "rolify", "~> 6.0.1"
gem "sentry-rails", "~> 5.13.0"
gem "sentry-ruby", "~> 5.13.0"
gem "simple_form", "~> 5.3.0"
gem "stimulus-rails"
gem "turbo-rails", "~> 1.5.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "validates_email_format_of", "~> 1.7.2"
gem "validates_timeliness", "~> 7.0.0.beta1"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails", "~> 6.2.0"
  gem "rspec-rails", "~> 6.0.1"
  gem "rubocop-rails", "2.21.1", require: false
  gem "rubocop-rspec", require: false
  gem "standard", require: false
end

group :development do
  gem "dockerfile-rails", ">= 1.5"
  gem "erb_lint", require: false
  gem "web-console"
end

group :test do
  gem "capybara", "~> 3.40.0"
  gem "rack_session_access"
  gem "rails-controller-testing", "~> 1.0.5"
  gem "selenium-webdriver", "~> 4.21.0"
  gem "shoulda-callback-matchers", "~> 1.1.4"
  gem "shoulda-matchers", "~> 5.3.0"
  gem "simplecov", require: false
end

group :productiom do
  gem "matrix", "~> 0.4.2"
end
