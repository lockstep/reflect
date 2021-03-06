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
          expect(@employment.responses.count).to eq 0
        end
      end
      context 'announce: Hey there' do
        before do
          @another_user = create(:user)
          @another_employment = create(
            :employment, user: @another_user, company: @company
          )
        end
        it 'sends message to all users via reflect bot' do
          client_double = double('SlackWebApiClient')
          expect(SlackWebApiClient)
            .to receive(:new).twice.and_return(client_double)
          expect(client_double).to receive(:send_message)
            .with(@employment, 'Hey there')
          expect(client_double).to receive(:send_message)
            .with(@another_employment, 'Hey there')
          execute_message('announce: Hey there')
          expect(@company.announcements.count).to eq 1
          expect(@company.announcements.first.text).to eq 'Hey there'
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
    context 'hey there' do
      before { execute_message('hey there') }
      it 'records the response' do
        response = @employment.responses.first
        expect(response.text).to eq 'hey there'
      end
    end
  end

  private

  def execute_message(message)
    SlackMessageHandler.new(
      company: @company, employment: @employment, message: message
    ).process!
  end
end
