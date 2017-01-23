describe InquisitionScheduler do
  before do
    @company = create(:company)
    @user = create(:user)
    @employment = create(
      :employment, user: @user, company: @company, time_zone: 'Asia/Bangkok'
    )
    Time.zone = 'Asia/Bangkok'
  end
  context 'the company has a question' do
    before { @question = create(:question, text: 'my q', company: @company) }
    context 'the employee has no upcoming inquiries' do
      it 'spawns inquries for employees within the time period' do
        InquisitionScheduler.new.perform
        inquiry = Inquiry.last
        expect(inquiry.employment).to eq @employment
        expect(inquiry.question).to eq @question
        expect(inquiry.to_be_delivered_at.hour).to be < 17
        expect(inquiry.to_be_delivered_at.hour).to be > 8
      end
    end
    context 'the employee has an inquiry for the week' do
      before do
        @inquiry = create(
          :inquiry, employment: @employment, question: @question,
          to_be_delivered_at: Time.now
        )
      end
      it 'does not schedule another inquiry' do
        InquisitionScheduler.new.perform
        expect(Inquiry.count).to eq 1
      end
    end
  end
  context 'the company has no questions' do
    it 'does not create an inquiry' do
      InquisitionScheduler.new.perform
      expect(Inquiry.count).to eq 0
    end
  end
end
