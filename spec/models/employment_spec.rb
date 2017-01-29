describe Employment do
  before do
    @company = create(:company)
    @user = create(:user)
    @employment = create(:employment, company: @company, user: @user)
  end
  describe '#optimal_question' do
    context 'a question exists' do
      before do
        @question = create(:question, company: @company)
      end
      it 'returns the question' do
        expect(@employment.optimal_question).to eq @question
      end
      context 'the question has been asked before' do
        before do
          @inquiry =
            create(:inquiry, question: @question, employment: @employment)
        end
        it 'returns no question' do
          expect(@employment.optimal_question).to be_nil
        end
      end
    end
  end
end
