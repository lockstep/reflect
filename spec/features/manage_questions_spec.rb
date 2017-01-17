feature 'Manage Questions' do
  background do
    @user = create(:user)
  end

  context 'user is logged in' do
    include_context 'logged in user'
    context 'user is company admin' do
      background do
        @company = create(:company)
        @company.add_admin(@user)
      end

      scenario 'user creates a question' do
        visit root_path
        fill_in :question_text, with: 'my quest'
        click_button 'Add Question'
        expect(page).to have_content 'my quest'
      end
    end
  end
end
