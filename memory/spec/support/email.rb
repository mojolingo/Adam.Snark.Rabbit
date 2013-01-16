def assert_email_sent(attributes = {})
  ActionMailer::Base.clear_cache
  yield
  email = ActionMailer::Base.cached_deliveries.last || ActionMailer::Base.deliveries.last
  email.should_not be_nil
  attributes.each_pair do |key, value|
    email.send(key).should == value
  end
end

def assert_email_not_sent
  ActionMailer::Base.clear_cache
  yield
  ActionMailer::Base.cached_deliveries.should be_empty
end

