class Inquirer

  def initialize(company)
    @company = company
  end

  def question!
    @company.employments.find_each do |employment|
      question = @company.get_question_for(employment)
      @company.slack_client.send_message(employment.slack_id, question.text)
    end
  end

end
