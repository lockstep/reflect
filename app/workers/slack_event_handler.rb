class SlackEventHandler
  include Sidekiq::Worker

  def perform(event_params)
    return unless event_params['token'] == ENV['SLACK_VERIFICATION_TOKEN']
    event = event_params['event']
    return if event['type'] != 'message' || event['subtype'] == 'bot_message'
    company = Company.find_by(slack_id: event_params['team_id'])
    employment = company.employments.find_by(slack_id: event['user'])
    employment.send_message("Received: #{event['text']}")
  end
end
