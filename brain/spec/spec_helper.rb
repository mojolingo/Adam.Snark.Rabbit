# encoding: utf-8

ENV["AHN_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'adhearsion/rspec'
require 'rspec/autorun'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before { WebMock.disable_net_connect! }
end

ENV['ADAM_ROOT_DOMAIN'] = 'local.adamrabbit.com:3000'
ENV['ADAM_INTERNAL_PASSWORD'] = 'foobar'
