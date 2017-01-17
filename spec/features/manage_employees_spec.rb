feature 'Manage Employees' do
  background do
    @user = create(:user)
  end

  context 'user is signed in' do
    include_context 'logged in user'
    context 'user is company admin' do
      background do
        @company = create(:company)
        @company.add_admin(@user)
      end

      scenario 'user adds employee' do
        visit root_path
        fill_in :employment_form_email, with: 'paul@locksteplabs.com'
        fill_in :employment_form_slack_handle, with: 'hiattp'
        click_button 'Add Employee'
        expect(page).to have_content 'paul@lockstep'
      end
    end
  end
end
