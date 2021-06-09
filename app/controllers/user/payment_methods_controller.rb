class User::PaymentMethodsController < User::UserController
  def index
    @company = Company.find_by(token: params[:company_token])
    @payment_methods = PaymentMethod.available
  end

  def show
    @company = Company.find_by(token: params[:company_token])
    @payment_method = PaymentMethod.find(params[:id])
  end
end