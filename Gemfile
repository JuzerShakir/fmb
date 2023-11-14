source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.2"

gem "rails", "~> 7.1"

gem "active_record_union"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "cancancan"
gem "cssbundling-rails"
gem "faker", "~> 3.1.0"
gem "friendly_id", "~> 5.5.0"
gem "humanize", "~> 2.5"
gem "jbuilder"
gem "jsbundling-rails"
gem "pagy", "~> 6.0"
gem "pg", "~> 1.1"
gem "prawn", "~> 2.4"
gem "prawn-table", "~> 0.2.2"
gem "propshaft"
gem "puma", "~> 6.4"
gem "rails-i18n"
gem "ransack", "~> 3.2.1"
gem "redis", "~> 4.0"
gem "rolify"
gem "sentry-rails", "~> 5.13"
gem "sentry-ruby", "~> 5.13"
gem "simple_form", "~> 5.1"
gem "stimulus-rails"
gem "turbo-rails"
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
  gem "capybara"
  gem "rack_session_access"
  gem "rails-controller-testing", "~> 1.0.5"
  gem "selenium-webdriver", "~> 4.7"
  gem "shoulda-callback-matchers", "~> 1.1.1"
  gem "shoulda-matchers", "~> 5.0"
  gem "simplecov", require: false
end

group :productiom do
  gem "matrix", "~> 0.4.2"
end
