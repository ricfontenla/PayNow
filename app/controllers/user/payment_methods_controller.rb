class User::PaymentMethodsController < User::UserController
  def index
    @payment_methods = PaymentMethod.available
  end
end