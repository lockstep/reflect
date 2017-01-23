class Inquirer

  def initialize(company)
    @company = company
  end

  def inquire!
    @company.employments.find_each do |employment|
      latest_inquiry = Inquiry.where(employment: employment).undelivered
        .order(to_be_delivered_at: :asc).last
      next unless latest_inquiry
      next if latest_inquiry.to_be_delivered_at > Time.now
      next if latest_inquiry.to_be_delivered_at < 2.hours.ago
      question = latest_inquiry.question
      employment.send_message(question.text)
      latest_inquiry.update(delivered_at: Time.now)
    end
  end

end
