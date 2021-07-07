class User::UserController < ApplicationController
  layout 'user'

  def is_customer_admin?
    redirect_to root_path unless current_user.customer_admin?
  end
end
