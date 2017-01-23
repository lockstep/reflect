class SlackMessageHandler
  def initialize(company:, employment:, message:)
    @company = company
    @employment = employment
    @message = message
  end

  def process!
    process_action
    # process_response
  end

  private

  def process_action
    return unless @employment.admin?
    case @message
    when /add question:/
      question = @message.split(':').last.strip
      @company.questions.create(text: question)
    end
  end
end