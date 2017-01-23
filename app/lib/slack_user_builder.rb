class SlackUserBuilder
  def initialize(company, user_data)
    @company = company
    @user_data = user_data
  end

  def create_or_update!
    return if @user_data['is_bot'] || @user_data['name'] == 'slackbot'
    @user = User
      .create_with(password: Devise.friendly_token)
      .find_or_create_by(email: @user_data['profile']['email'])
    @employment = @company.employments
      .find_or_create_by(slack_id: @user_data['id'])
    update_employment!
    @employment.update(role: :admin) if @user_data['is_owner']
    open_dm_channel!
  end

  private

  def update_employment!
    @employment.update!(
      user: @user,
      slack_handle: @user_data['name'],
      slack_id: @user_data['id'],
      archived: user_archived_or_restricted?,
      time_zone: @user_data['tz'],
      # Seems like this is redundant with the user record in latest
      # implementation.
      email: @user_data['profile']['email']
    )
  end

  def open_dm_channel!
    return if @employment.archived?
    channel_data = @company.bot_client.open_im(@user_data['id'])
    @employment.update(slack_dm_channel_id: channel_data['channel']['id'])
  end

  def user_archived_or_restricted?
    archived_states = [ 'deleted', 'is_restricted', 'is_ultra_restricted' ]
    archived_states.any? { |s| @user_data[s] }
  end
end
