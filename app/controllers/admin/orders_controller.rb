class Admin::OrdersController < Admin::AdminController
  def index
    @company = Company.find(params[:company_id])
    @orders = @company.orders.order(id: :desc)
  end

  def show
    @company = Company.find(params[:company_id])
    @order = Order.find(params[:id])
  end

  def edit
    @company = Company.find(params[:company_id])
    @order = Order.find(params[:id])
    response_list
  end

  def update
    @company = Company.find(params[:company_id])
    @order = Order.find(params[:id])
    @order_history = @order.order_histories.new(order_histories_params)
    if @order.update(order_params) && @order_history.save
      flash[:notice] = t('.success')
      redirect_to admin_company_order_path(@company, @order)
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end

  def order_histories_params
    params.require(:order).permit(:status, :response_code)
  end
  
  def response_list
    @response_code = ['01 - Pendente de cobrança', 
                      '05 - Cobrança efetivada com sucesso', 
                      '09 - Cobrança recusada por falta de créditos', 
                      '10 - Cobrança recusada por dados incorretos para cobrança', 
                      '11 - Cobrança recusada sem motivo especificado']
  end
end