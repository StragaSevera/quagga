require 'rails_helper'
require 'capybara/poltergeist'

Dir[File.dirname(__FILE__) + "/features/concerns/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!

  config.include FeatureMacros, type: :feature

  config.include SphinxHelpers, type: :feature

  config.before(:suite) do
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end
end

Capybara::Screenshot.autosave_on_failure = false

Capybara.configure do |config|
  config.asset_host = "http://localhost:3000"
  config.javascript_driver = :poltergeist
end