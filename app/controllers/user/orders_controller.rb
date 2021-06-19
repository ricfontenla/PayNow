class User::OrdersController < User::UserController
  def index
    @company =  Company.find_by(token: params[:company_token])
    @orders =  @company.orders.by_date(30.days.ago)
  end

  def last_90_days
    @company =  Company.find_by(token: params[:company_token])
    @orders =  @company.orders.by_date(90.days.ago)
    render :index
  end

  def all_orders
    @company =  Company.find_by(token: params[:company_token])
    @orders =  @company.orders
    render :index
  end
end