class User::CardAccountsController < User::UserController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_payment_method, only: %i[new create edit update]
  before_action :set_card_account, only: %i[edit update destroy]

  def new
    @card_account = CardAccount.new
  end

  def create
    @card_account = @company.card_accounts.build(card_params)
    @card_account.payment_method_id = @payment_method.id
    if @card_account.save
      redirect_to my_payment_methods_user_company_path(@company.token)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @card_account.update(card_params)
      flash[:notice] = t('.success')
      redirect_to my_payment_methods_user_company_path(@company.token)
    else
      render :edit
    end
  end

  def destroy
    @card_account.destroy
    flash[:notice] = t('.success')
    redirect_to my_payment_methods_user_company_path(@company.token)
  end

  private

  def card_params
    params.require(:card_account).permit(:credit_code)
  end

  def set_company
    @company = Company.find_by(token: params[:company_token])
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    redirect_to root_path unless @payment_method.card?
  end

  def set_card_account
    @card_account = CardAccount.find(params[:id])
  end
end
