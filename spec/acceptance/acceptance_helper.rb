require 'rails_helper'

RSpec.configure do |config|
  config.include AcceptanceMacros, type: :feature

  # Capybara config to avoid some annoying messages
  Capybara::Webkit.configure do |config|
    # Enable debug mode. Prints a log of everything the driver is doing.
    config.debug = false

    config.allow_unknown_urls
    # Allow pages to make requests to any URL without issuing a warning.

    # Allow a specifc domain without issuing a warning.
    config.allow_url("placehold.it")

    # Timeout if requests take longer than 5 seconds
    config.timeout = 10

    # Don't raise errors when SSL certificates can't be validated
    config.ignore_ssl_errors
  end

  Capybara.javascript_driver = :webkit

  Capybara.default_wait_time = 5

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
