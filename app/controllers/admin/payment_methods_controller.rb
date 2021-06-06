class Admin::PaymentMethodsController < Admin::AdminController
  def index
    @payment_methods = PaymentMethod.all
  end

  def show
    @payment_method = PaymentMethod.find(params[:id])
  end
end