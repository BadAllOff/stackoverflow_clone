require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rails_helper'

RSpec.configure do |config|

  Capybara.javascript_driver = :webkit

  Capybara::Webkit.configure do |config|
    config.block_unknown_urls
  end
  Capybara.default_max_wait_time = 5

  config.include AcceptanceMacros, type: :feature

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

  config.before(:each, :sphinx => true) do
    # For tests tagged with Sphinx, use deletion (or truncation)
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.around(:each) do |spec|
    if spec.metadata[:js]
      # JS => doesn't share connections => can't use transactions
      spec.run
      DatabaseCleaner.clean_with :deletion
    else
      # No JS/Devise => run with Rack::Test => transactions are ok
      DatabaseCleaner.start
      spec.run
      DatabaseCleaner.clean

      # see https://github.com/bmabey/database_cleaner/issues/99
      begin
        ActiveRecord::Base.connection.send :rollback_transaction_records, true
      rescue
      end
    end
  end
end
