describe CompaniesController do
  describe '#show' do
    xcontext 'user is not signed in' do
      it 'redirects user' do
        get :show, params: { id: 0 }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
