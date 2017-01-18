describe EmploymentsController do
  describe '#create' do
    # In new slack-only flow this is deprecated
    xcontext 'company exists' do
      before do
        @company = create(:company)
      end
      it 'gets slack info for the user' do
        post :create, params: {
          employment_form: {
            company_id: @company.id,
            email: 'paul@locksteplabs.com',
            slack_handle: 'hiattp'
          }
        }
        SlackUserIdentifier.drain
        # NOTE: This id comes from the mock data in slack/users.list.json.
        expect(Employment.last.slack_id).to eq 'U13J5O0C9'
      end
    end
  end
end
