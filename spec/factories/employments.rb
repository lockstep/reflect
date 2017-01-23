FactoryGirl.define do
  factory :employment do
    company nil
    user nil
    slack_id 'MYID'
    slack_dm_channel_id 'dmid'
  end
end
