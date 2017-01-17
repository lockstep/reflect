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
        before { @employment.update(slack_id: 'MYID') }
        it 'sends the employee the question via slack' do
          expect_any_instance_of(SlackWebApiClient).to receive(:send_message)
            .with('MYID', 'my q').and_call_original
          Inquirer.new(@company).question!
        end
      end
      context 'the employee does not yet have a slack id' do

      end
    end
  end
end
