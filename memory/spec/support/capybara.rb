require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/email/rspec'

Capybara.javascript_driver = :poltergeist

module Capybara::Email::DSL
  def all_emails
    ActionMailer::Base.cached_deliveries
  end

  def clear_emails
    ActionMailer::Base.clear_cache
  end
end
