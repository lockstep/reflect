class EmploymentsController < ApplicationController

  def create
    @employment_form = EmploymentForm.new(employment_params)
    @employment_form.employ_user!
    redirect_back(fallback_location: root_path)
  end

  private

  def employment_params
    params.require(:employment_form).permit(
      :email, :slack_handle, :company_id
    )
  end

end
