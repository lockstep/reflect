class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def oauth
    if code = params[:code]
      create_or_update_company(code)
      redirect_to root_path, notice: 'Slack integration complete!'
    else
      redirect_to root_path, alert: 'Slack authentication failed.'
    end
  end

  def events
    if params[:type] == 'url_verification'
      render json: { challenge: params[:challenge] }
    else
      SlackEventHandler.perform_async(params)
      head :ok
    end
  end

  private

  def create_or_update_company(code)
    company_data = SlackWebApiClient.get_company_data(code, slack_oauth_url)
    company = Company.find_or_create_by(slack_id: company_data['team_id'])
    company.update(
      name: company_data['team_name'],
      slack_access_token: company_data['access_token'],
      slack_bot_user_id: company_data['bot']['bot_user_id'],
      slack_bot_access_token: company_data['bot']['bot_access_token'],
    )
    SlackUserIdentifier.perform_in(1.second, company.id)
  end

end
