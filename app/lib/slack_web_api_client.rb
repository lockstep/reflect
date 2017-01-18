class SlackWebApiClient

  BASE_URI = 'https://slack.com/api'
  CLIENT_ID = ENV['SLACK_CLIENT_ID']
  CLIENT_SECRET = ENV['SLACK_CLIENT_SECRET']

  def initialize(slack_token)
    @slack_token = slack_token
  end

  def self.get_company_data(code, redirect_uri)
    res = RestClient.get("#{BASE_URI}/oauth.access", {
      params: {
        code: code,
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        redirect_uri: redirect_uri
      }
    })
    JSON.parse(res.body)
  end

  def users_list
    res = RestClient.get("#{BASE_URI}/users.list", {
      params: {
        token: @slack_token
      }
    })
    JSON.parse(res.body)['members']
  end

  def open_im(slack_id)
    res = RestClient.get("#{BASE_URI}/im.open", {
      params: {
        token: @slack_token,
        user: slack_id,
      }
    })
    JSON.parse(res.body)
  end

  def send_message(employment, message)
    # TEMP: Limit messaging to hiattp
    return unless employment.slack_handle == 'hiattp'
    RestClient.get("#{BASE_URI}/chat.postMessage", {
      params: {
        token: @slack_token,
        channel: employment.slack_dm_channel_id,
        text: message,
        username: 'Reflect',
        as_user: false
      }
    })
  end
end
