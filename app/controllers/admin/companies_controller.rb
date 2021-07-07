class Admin::CompaniesController < Admin::AdminController
  before_action :authenticate_admin!
  before_action :set_company, only: %i[show edit update generate_token]

  def index
    @companies = Company.all.sort_by(&:name)
  end

  def show; end

  def edit; end

  def update
    if @company.update(company_params)
      flash[:notice] = t('.success')
      redirect_to [:admin, @company]
    else
      render :edit
    end
  end

  def generate_token
    @company.token = create_unique_token
    if @company.save
      flash[:notice] = t('.success')
    else
      flash[:alert] = t('.fail')
    end
    redirect_to [:admin, @company]
  end

  private

  def company_params
    params.require(:company).permit(:name, :cnpj, :billing_adress, :billing_email)
  end

  def set_company
    @company = Company.find(params[:id])
  end

  def create_unique_token
    new_token = SecureRandom.base58(20)
    duplicity = Company.where(token: new_token)
    create_unique_token if duplicity.any?
    new_token
  end
end
