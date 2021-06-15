class Admin::OrdersController < Admin::AdminController
  before_action :authenticate_admin!, only: [:index, :show, :edit, :update]
  before_action :set_company, only: [:index, :show, :edit, :update]
  before_action :set_order, only: [:show, :edit, :update]
  before_action :status_verification, only: [:update]

  def index
    @orders = @company.orders.order(id: :desc)
  end

  def show
  end

  def edit
    response_list
  end

  def update
    @order_history = @order.order_histories.new(order_histories_params)
    if @order.update(order_params) && @order_history.save
      Receipt.create(order: @order) if @order.aprovado?
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

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def status_verification
    redirect_to root_path unless @order.pendente?
  end
end