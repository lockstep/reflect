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

  def send_message(slack_id, message)
    RestClient.get("#{BASE_URI}/chat.postMessage", {
      params: {
        token: @slack_token,
        channel: slack_id,
        text: message
      }
    })
  end
end
