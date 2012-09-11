FactoryGirl.define do
  factory :jid do
    address "foo@bar.com"
    association :profile
  end
end
