# encoding: utf-8

ENV["AHN_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'adhearsion/rspec'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :mocha

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  Mocha::Configuration.warn_when :stubbing_non_existent_method
  Mocha::Configuration.warn_when :stubbing_non_public_method
end
