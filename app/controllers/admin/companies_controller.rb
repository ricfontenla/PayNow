class Admin::CompaniesController < Admin::AdminController
  def index
    @companies = Company.all.sort_by { |company| company.name }
  end

  def show
    @company = Company.find(params[:id])
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      flash[:notice] = t('.success')
      redirect_to [:admin, @company]
    else
      render :edit
    end
  end

  def generate_token
    @company = Company.find(params[:id])
    @company.token = create_unique_token
    if @company.save
      flash[:notice] = t('.success')
      redirect_to [:admin, @company]
    else
      flash[:alert] = t('.fail')
      redirect_to [:admin, @company]
    end
  end

  private
  def company_params
    params.require(:company).permit(:name, :cnpj, :billing_adress, :billing_email)
  end

  def create_unique_token
    new_token = SecureRandom.base58(20)
    duplicity = Company.where(token: new_token)
    create_unique_token if duplicity.any?
    new_token
  end
end