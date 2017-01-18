xfeature 'Manage Company' do
  background do
    @user = create(:user)
  end

  context 'the user is not logged in' do
    scenario 'the user is told to log in before creating a co' do
      visit root_path
      expect(page).not_to have_field :company_name
      click_link 'log in'
      fill_in :user_email, with: @user.email
      fill_in :user_password, with: 'password'
      click_button 'Log in'
      expect(page).to have_field :company_name
    end
  end

  context 'user is logged in' do
    include_context 'logged in user'

    context 'user does not have a company' do
      scenario 'user creates a company' do
        visit root_path
        fill_in :company_name, with: 'My Co'
        click_button 'Create'
        expect(page).to have_content 'My Co Employees'
        # Attempt to go "home"
        visit root_path
        expect(page).to have_content 'My Co Employees'
      end
    end
  end
end
