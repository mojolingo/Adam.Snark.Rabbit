# encoding: utf-8

require 'bundler/setup'
Bundler.require
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
