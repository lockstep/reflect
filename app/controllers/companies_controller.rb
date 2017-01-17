class CompaniesController < ApplicationController
  before_action :authenticate_user!

  def create
    @company = Company.create(company_params)
    @company.add_admin(current_user)
    redirect_to @company
  end

  def show
    @company = Company.find(params[:id])
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end
end
