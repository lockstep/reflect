include Warden::Test::Helpers

shared_context 'logged in user' do
  background do
    Warden.test_mode!
    login_as(@user, :scope => :user)
  end
  after(:each) do
    Warden.test_reset!
  end
end
