class Admin::CompaniesController < Admin::AdminController
  def index
    @companies = Company.all.sort_by { |company| company.name }
  end

  def show
    @company = Company.find(params[:id])
  end
end