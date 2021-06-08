class Admin::PaymentMethodsController < Admin::AdminController
  before_action :set_payment_method, only: [:show, :edit, :update, :destroy]

  def index
    @payment_methods = PaymentMethod.all
  end

  def show
  end

  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      set_icon
      redirect_to [:admin, @payment_method]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @payment_method.update(payment_method_update_params)
      flash[:notice] = t('.success')
      redirect_to [:admin, @payment_method]
    else
      render :edit
    end
  end

  def destroy
    @payment_method.destroy
    flash[:notice] = t('.success')
    redirect_to admin_payment_methods_path
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name, :billing_fee, :max_fee, :status, :category)
  end

  def payment_method_update_params
    params.require(:payment_method).permit(:billing_fee, :max_fee, :status)
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

  def set_icon
    if @payment_method.boleto?
      @payment_method.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/boleto.png')), 
                filename: 'boleto.png')
    elsif @payment_method.card?
      @payment_method.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/card.png')), 
                filename: 'card.png')
    else  @payment_method.pix?
      @payment_method.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/pix.png')), 
                filename: 'pix.png')
    end
  end
end