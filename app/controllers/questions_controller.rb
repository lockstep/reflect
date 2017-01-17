class QuestionsController < ApplicationController

  def create
    @company = Company.find(params[:company_id])
    @question = @company.questions.create(question_params)
    redirect_back(fallback_location: root_path)
  end

  private

  def question_params
    params.require(:question).permit(:text)
  end
end
