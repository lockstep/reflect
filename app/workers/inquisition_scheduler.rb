class InquisitionScheduler
  include Sidekiq::Worker

  def perform
    Company.find_each do |company|
      company.employments.find_each do |employment|
        employment.schedule_inquiry!
      end
    end
  end

end
