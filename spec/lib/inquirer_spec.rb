describe Inquirer do
  context 'a company exists with employees' do
    before do
      @company = create(:company)
      @user = create(:user)
      @employment = create(:employment, user: @user, company: @company)
    end
    context 'the company has a question' do
      before do
        @question = create(:question, text: 'my q', company: @company)
      end
      context 'the employee has a slack id' do
        before do
          @employment.update(slack_id: 'MYID', slack_dm_channel_id: 'dmid')
        end
        it 'sends the employee the question via slack' do
          expect_any_instance_of(SlackWebApiClient).to receive(:send_message)
            .with(@employment, 'my q').and_call_original
          Inquirer.new(@company).question!
        end
      end
      context 'the employee does not yet have a slack id' do
        it 'does not trigger question' do
          expect(SlackWebApiClient).not_to receive(:new)
          Inquirer.new(@company).question!
        end
      end
    end
  end
end
