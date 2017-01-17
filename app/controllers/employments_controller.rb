class EmploymentsController < ApplicationController

  def create
    @employment_form = EmploymentForm.new(employment_params)
    @employment = @employment_form.employ_user!
    SlackUserIdentifier.perform_in(1.second, @employment.id)
    redirect_back(fallback_location: root_path)
  end

  private

  def employment_params
    params.require(:employment_form).permit(
      :email, :slack_handle, :company_id
    )
  end

end
