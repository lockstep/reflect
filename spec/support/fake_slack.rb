require 'sinatra/base'

class FakeSlack < Sinatra::Base

  get '/api/users.list' do
    ensure_required_params(:token)
    json_response 200, 'users.list.json'
  end

  get '/api/im.open' do
    ensure_required_params(:token, :user)
    raise 'user archived' if params[:user] == 'U04S4SE2_OLD'
    json_response 200, 'im.open.json'
  end

  get '/api/oauth.access' do
    ensure_required_params(:client_id, :client_secret, :code, :redirect_uri)
    json_response 200, 'oauth.access.json'
  end

  get '/api/chat.postMessage' do
    ensure_required_params(:token)
    json_response 200, 'chat.postMessage.json'
  end

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(
      Rails.root.join('spec', 'fixtures', 'slack', file_name), 'rb'
    )
  end

  def ensure_required_params(*required_params)
    required_params.each do |required_param|
      if params[required_param].blank?
        raise "Required param missing: #{required_param}"
      end
    end
  end

end
