class User::CompaniesController < User::UserController
  def show
    @company = Company.find_by(token: params[:token])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    set_email_domain(@company)
    if @company.save
      current_user.customer_admin!
      set_company_id_for_user
      redirect_to user_company_path(@company.token)
    else
      render :new
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :cnpj, :billing_adress, :billing_email)
  end

  def set_email_domain(company)
    company.email_domain = current_user.email.split('@').last
  end

  def set_company_id_for_user
    current_user.company = @company
    current_user.save
  end
end