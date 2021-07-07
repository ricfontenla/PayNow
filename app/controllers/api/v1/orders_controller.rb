class Api::V1::OrdersController < ActionController::API
  def index
    @company = Company.find_by!(token: params[:company][:token])
    if params[:created_at] && params[:choosen_payment]
      @orders = @company.orders.by_date(params[:created_at]).by_type(params[:choosen_payment])
    elsif params[:created_at] && params[:choosen_payment].nil?
      @orders = @company.orders.by_date(params[:created_at])
    elsif params[:choosen_payment] && params[:created_at].nil?
      @orders = @company.orders.by_type(params[:choosen_payment])
    end
    render json: { message: 'Nenhum resultado encontrado' } and return unless @orders

    render json: @orders.as_json(except: %i[id company_id product_id final_customer_id],
                                 include: {
                                   company: { only: [:token] },
                                   product: { only: [:token] },
                                   final_customer: { only: [:token] }
                                 })
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Token Inválido' }, status: :not_found
  end

  def create
    return render json: { message: 'Parâmetros Inválidos' }, status: :precondition_failed unless params[:order]

    @company = Company.find_by!(token: params[:order][:company_token])
    @product = @company.products.find_by!(token: params[:order][:product_token])
    @final_customer = @company.final_customers.find_by!(token: params[:order][:final_customer_token])
    case params[:order][:choosen_payment]
    when 'boleto'
      @order = @company.orders.build(order_boleto_params)
      @order.product = @product
      @order.final_customer = @final_customer
      set_boleto_price
      @order.save!
      render json: @order.as_json(except: %i[id created_at updated_at
                                             card_number printed_name
                                             verification_code company_id
                                             product_id final_customer_id],
                                  include: { company: { only: [:token] },
                                             product: { only: [:token] },
                                             final_customer: { only: [:token] } }), status: :created
    when 'card'
      @order = @company.orders.build(order_card_params)
      @order.product = @product
      @order.final_customer = @final_customer
      set_card_price
      @order.save!
      render json: @order.as_json(except: %i[id created_at updated_at
                                             adress company_id product_id
                                             final_customer_id],
                                  include: { company: { only: [:token] },
                                             product: { only: [:token] },
                                             final_customer: { only: [:token] } }), status: :created
    when 'pix'
      @order = @company.orders.build(order_pix_params)
      @order.product = @product
      @order.final_customer = @final_customer
      set_pix_price
      @order.save!
      render json: @order.as_json(except: %i[id created_at updated_at
                                             adress card_number printed_name
                                             verification_code company_id
                                             product_id final_customer_id],
                                  include: { company: { only: [:token] },
                                             product: { only: [:token] },
                                             final_customer: { only: [:token] } }), status: :created
    else
      render json: { message: 'Método de Pagamento Inválido' }, status: :precondition_failed
    end
  rescue ActiveRecord::RecordInvalid
    render json: { message: 'Parâmetros Inválidos' }, status: :precondition_failed
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Token Inválido' }, status: :precondition_failed
  end

  def update
    @order = Order.find_by!(token: params[:token])
    if @order.update!(update_order_params)
      @order.order_histories.create!(order_history_params)
      render json: @order.as_json(except: %i[id company_id final_customer_id
                                             product_id created_at updated_at],
                                  include: { company: { only: [:token] },
                                             product: { only: [:token] },
                                             final_customer: { only: [:token] },
                                             order_histories: { only: [:response_code] } })
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Token Inválido' }, status: :not_found
  rescue ActiveRecord::RecordInvalid
    render json: { message: 'Parâmetros Inválidos' }, status: :precondition_failed
  end

  private

  def order_boleto_params
    params.require(:order).permit(:choosen_payment, :adress)
  end

  def order_card_params
    params.require(:order).permit(:choosen_payment, :card_number,
                                  :printed_name, :verification_code)
  end

  def order_pix_params
    params.require(:order).permit(:choosen_payment)
  end

  def set_boleto_price
    @order.original_price = @product.price
    @order.final_price = @product.price - (@product.price * @product.boleto_discount / 100)
  end

  def set_card_price
    @order.original_price = @product.price
    @order.final_price = @product.price - (@product.price * @product.card_discount / 100)
  end

  def set_pix_price
    @order.original_price = @product.price
    @order.final_price = @product.price - (@product.price * @product.pix_discount / 100)
  end

  def update_order_params
    params.require(:order).permit(:status)
  end

  def order_history_params
    params.require(:order).permit(:status, :response_code)
  end
end
