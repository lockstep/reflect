describe SlackMessageHandler do
  before do
    @company = create(:company)
    @user = create(:user)
    @employment =
      create(:employment, user: @user, company: @company, role: :admin)
  end
  context 'action' do
    context 'user is an admin' do
      context 'add question: Whats up?' do
        before { execute_message('add question: Whats up?') }
        it 'creates a question for the company' do
          question = @company.questions.first
          expect(question.text).to eq 'Whats up?'
        end
      end
    end
    context 'user is not an admin' do
      before { @employment.update(role: nil) }
      context 'add question: Whats up?' do
        before { execute_message('add question: Whats up?') }
        it 'does not create a question for the company' do
          expect(Question.count).to eq 0
        end
      end
    end
  end
  context 'non-action (response)' do
    
  end

  private

  def execute_message(message)
    SlackMessageHandler.new(
      company: @company, employment: @employment, message: message
    ).process!
  end
end
