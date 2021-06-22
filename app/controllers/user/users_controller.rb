class User::UsersController < User::UserController
  before_action :authenticate_user!, only: [:update]
  before_action :customer_admin_authentication, only: [:update]

  def update
    @company = Company.find_by(token: params[:company_token])
    @user = @company.users.find(params[:id])
    @user.status? ? (@user.status = false) : (@user.status = true)
    @user.save!
    redirect_to user_company_path(@company.token)
  end

  private

  def customer_admin_authentication
    redirect_to root_path unless current_user.customer_admin?
  end
end