FactoryGirl.define do
  factory :email_address do
    address "foo@bar.com"
    association :profile
  end
end
