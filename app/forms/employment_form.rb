class EmploymentForm
  include ActiveModel::Model

  attr_accessor :email, :slack_handle, :company_id

  def employ_user!
    company = Company.find(company_id)
    # NOTE: This returns the new Employment object
    company.add_employee(email, slack_handle)
  end

end
