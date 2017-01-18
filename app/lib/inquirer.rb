class Inquirer

  def initialize(company)
    @company = company
  end

  def question!
    @company.employments.find_each do |employment|
      next if employment.slack_id.blank?
      question = @company.get_question_for(employment)
      @company.bot_client.send_message(employment, question.text)
    end
  end

end
