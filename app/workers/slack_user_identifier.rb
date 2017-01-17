class SlackUserIdentifier
  include Sidekiq::Worker

  def perform(employment_id)
    employment = Employment.find(employment_id)
    slack_id = get_slack_user_id(employment.slack_handle)
    employment.update(slack_id: slack_id)
  end

  private

  def get_slack_user_id(slack_handle)
    slack_client = SlackWebApiClient.new(ENV['SLACK_TOKEN'])
    users_data = slack_client.users_list
    matching_data = users_data.detect { |data| data["name"] == slack_handle }
    matching_data["id"]
  end
end
