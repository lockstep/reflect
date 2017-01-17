describe Company do
  describe '#add_employee' do
    context 'no user exists' do
      it 'creates the user' do
        company = create(:company)
        company.add_employee('test@example.com', 'test')
        expect(User.count).to eq 1
      end
    end
  end
end
