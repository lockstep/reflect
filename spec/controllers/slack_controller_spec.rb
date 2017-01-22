describe SlackController, type: :request do

  describe 'POST /slack/events' do
    context 'challenge request' do
      it 'sends the appropriate response' do
        post '/slack/events', params: {
          "token": "Jhj5dZrVaK7ZwHHjRyZWjbDl",
          "challenge": "3eZb",
          "type": "url_verification"
        }
        expect(response.body).to eq({ challenge: '3eZb' }.to_json)
      end
    end
  end

  describe 'GET /slack/oauth' do
    context 'a successful request' do
      context 'no previous company' do
        it 'creates the company and saves bot info' do
          # TODO: Add state param for request verification.
          get '/slack/oauth?code=test123'
          company = Company.first
          expect(company.name).to eq 'Test Team'
          expect(company.slack_access_token).to eq 'teamaccess123'
          expect(company.slack_bot_user_id).to eq 'bot123'
          expect(company.slack_bot_access_token).to eq 'botaccess123'
          SlackUserIdentifier.drain
          expect(company.employments.count).to eq 2
          admin = company.employments.find_by(slack_id: 'U13J5O0C9')
          non_admin = company.employments.find_by(slack_id: 'U04S4SE3G')
          expect(admin).to be_present
          expect(admin.slack_dm_channel_id).to eq 'D024BFF1M'
          expect(admin.role).to eq 'admin'
          expect(non_admin.role).to be_blank
        end
      end
      context 'previous company exists' do
        before { @company = create(:company, slack_id: 'team123', name: 'old') }
        it 'updates the company data' do
          # TODO: Add state param for request verification.
          get '/slack/oauth?code=test123'
          company = Company.first
          expect(company.name).to eq 'Test Team'
        end
      end
    end
    context 'an unsuccessful request' do
      it 'redirects back with the failure message' do
        get '/slack/oauth?error=access_denied&state='
        expect(response).to redirect_to root_path
      end
    end
  end
end
