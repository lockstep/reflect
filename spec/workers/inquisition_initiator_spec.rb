describe InquisitionInitiator do
  before do
    @company = create(:company)
  end
  it 'spawns inquirers for all companies' do
    expect(Inquirer).to receive(:new).with(@company).and_call_original
    expect_any_instance_of(Inquirer).to receive(:inquire!)
    InquisitionInitiator.new.perform
  end
end
