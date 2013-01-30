ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:suite) do
    cache_dir = "#{Rails.root}/tmp/cache/"
    FileUtils.mkdir_p(cache_dir) unless File.directory?(cache_dir)
    WebMock.disable_net_connect!
  end

  config.before do
    DatabaseCleaner.clean
    ActionMailer::Base.clear_cache
  end
end

DatabaseCleaner.strategy = :truncation
