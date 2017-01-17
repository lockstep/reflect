require 'sinatra/base'

class FakeSlack < Sinatra::Base

  get '/api/users.list' do
    if params[:token].blank?
      status 403
      return
    end
    json_response 200, 'users.list.json'
  end

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(
      Rails.root.join('spec', 'fixtures', 'slack', file_name), 'rb'
    )
  end
end
