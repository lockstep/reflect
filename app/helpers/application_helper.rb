module ApplicationHelper
  def add_to_slack_link
    # TODO: Add state param for request verification.
    scopes = [
      # NOTE: These are needed but come with the 'bot' scope:
      # im:read - Get the channels for DM channel ids.
      # chat:write:bot - Write messages as the bot
      # users:read - Get the list of users for a team to create user accounts
      'bot'
    ]
    <<-LINK.strip_heredoc.squish.gsub(/\s+/, "")
      https://slack.com/oauth/authorize?
      scope=#{scopes.join(',')}&
      client_id=#{ENV['SLACK_CLIENT_ID']}&
      redirect_uri=#{slack_oauth_url}
    LINK
  end
end
