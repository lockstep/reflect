FactoryGirl.define do
  factory :company do
    name "Test Co"
    slack_bot_access_token 'test_token'
  end
end
