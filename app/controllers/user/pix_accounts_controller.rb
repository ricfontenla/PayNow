require 'csv'

class User::PixAccountsController < User::UserController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_payment_method, only: [:new, :create, :edit, :update]
  before_action :set_pix_account, only: [:edit, :update, :destroy]
  before_action :bank_codes, only: [:new, :create, :edit, :update]

  def new
    @pix_account = PixAccount.new
  end

  def create
    @pix_account = @company.pix_accounts.build(pix_params)
    @pix_account.payment_method_id = @payment_method.id
    if @pix_account.save
      redirect_to my_payment_methods_user_company_path(@company.token)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @pix_account.update(pix_params)
      flash[:notice] = t('.success')
      redirect_to my_payment_methods_user_company_path(@company.token)
    else
      render :edit
    end
  end

  def destroy
    @pix_account.destroy
    flash[:notice] = t('.success')
    redirect_to my_payment_methods_user_company_path(@company.token)
  end

  private
  def pix_params
    params.require(:pix_account).permit(:bank_code, :pix_key)
  end

  def bank_codes
    csv = File.read(Rails.root.join('lib/assets/csv/bancos_associados.csv'))
    @bank_codes = CSV.parse(csv).map { |key, value| [key + ' - ' + value, key] }
  end

  def set_company
    @company = Company.find_by(token: params[:company_token])
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    redirect_to root_path unless @payment_method.pix?
  end

  def set_pix_account
    @pix_account = PixAccount.find(params[:id])
  end
end