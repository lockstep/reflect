class InquisitionInitiator
  include Sidekiq::Worker

  def perform
    Company.find_each do |company|
      Inquirer.new(company).inquire!
    end
  end
end
