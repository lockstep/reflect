class SlackWebApiClient

  BASE_URI = 'https://slack.com/api'

  def initialize(slack_token)
    @slack_token = slack_token
  end

  def users_list
    res = RestClient.get("#{BASE_URI}/users.list", {
      params: {
        token: @slack_token
      }
    })
    JSON.parse(res.body)['members']
  end
end
