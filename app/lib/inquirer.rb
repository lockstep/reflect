class Inquirer

  def initialize(company)
    @company = company
  end

  def question!
    @company.employments.find_each do |employment|
      next if employment.slack_id.blank?
      question = @company.get_question_for(employment)
      employment.send_message(question.text)
    end
  end

end
