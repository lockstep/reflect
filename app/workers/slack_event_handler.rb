class SlackEventHandler
  include Sidekiq::Worker

  def perform(event_params)
    return unless event_params['token'] == ENV['SLACK_VERIFICATION_TOKEN']
    event = event_params['event']
    return if event['type'] != 'message' || event['subtype'] == 'bot_message'
    company = Company.find_by(slack_id: event_params['team_id'])
    slack_id = event['user'] || event['message']['user']
    employment = company.employments.find_by(slack_id: slack_id)
    message_text = event['text'] || event['message']['text']
    SlackMessageHandler.new(
      company: company, employment: employment, message: message_text
    ).process!
  end
end
