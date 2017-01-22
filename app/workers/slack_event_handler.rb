class SlackEventHandler
  include Sidekiq::Worker

  def perform(event_params)
  end
end
