describe Inquirer do
  context 'a company exists with employees' do
    before do
      @company = create(:company)
      @user = create(:user)
      @employment = create(:employment, user: @user, company: @company)
    end
    context 'the employee has an inquiry' do
      before do
        @question = create(:question, text: 'my q', company: @company)
        @inquiry =
          create(:inquiry, question: @question, employment: @employment)
      end
      context 'the inquiry has not yet been sent' do
        context 'the inquiry is due' do
          before { @inquiry.update(to_be_delivered_at: 30.minutes.ago) }
          it 'sends the employee the question via slack' do
            expect_any_instance_of(SlackWebApiClient).to receive(:send_message)
              .with(@employment, 'my q').and_call_original
            Inquirer.new(@company).inquire!
            expect(@inquiry.reload.delivered_at).not_to be_nil
          end
        end
        context 'the inquiry is overdue' do
          before { @inquiry.update(to_be_delivered_at: 3.hours.ago) }
          it 'does not send - we missed the window' do
            expect_any_instance_of(SlackWebApiClient)
              .not_to receive(:send_message)
            Inquirer.new(@company).inquire!
            expect(@inquiry.reload.delivered_at).to be_nil
          end
        end
        context 'the inquiry is not due' do
          before { @inquiry.update(to_be_delivered_at: 1.day.from_now) }
          it 'does not send the question' do
            expect_any_instance_of(SlackWebApiClient)
              .not_to receive(:send_message)
            Inquirer.new(@company).inquire!
            expect(@inquiry.reload.delivered_at).to be_nil
          end
        end
      end
      context 'the inquiry has been sent' do
        before do
          @inquiry.update(
            to_be_delivered_at: 1.day.ago, delivered_at: 1.day.ago
          )
        end
        it 'does not send the question' do
          expect_any_instance_of(SlackWebApiClient)
            .not_to receive(:send_message)
          Inquirer.new(@company).inquire!
        end
      end
    end
    context 'no employments have inquiries' do
      it 'does nothing' do
        Inquirer.new(@company).inquire!
      end
    end
  end
end
