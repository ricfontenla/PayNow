require 'csv'

class User::BoletoAccountsController < User::UserController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_payment_method, only: %i[new create edit update]
  before_action :set_boleto_account, only: %i[edit update destroy]
  before_action :bank_codes, only: %i[new create edit update]

  def new
    @boleto_account = BoletoAccount.new
  end

  def create
    @boleto_account = @company.boleto_accounts.build(boleto_params)
    @boleto_account.payment_method_id = @payment_method.id
    if @boleto_account.save
      redirect_to my_payment_methods_user_company_path(@company.token)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @boleto_account.update(boleto_params)
      flash[:notice] = t('.success')
      redirect_to my_payment_methods_user_company_path(@company.token)
    else
      render :edit
    end
  end

  def destroy
    @boleto_account.destroy
    flash[:notice] = t('.success')
    redirect_to my_payment_methods_user_company_path(@company.token)
  end

  private

  def bank_codes
    csv = File.read(Rails.root.join('lib/assets/csv/bancos_associados.csv'))
    @bank_codes = CSV.parse(csv).map { |key, value| ["#{key} - #{value}", key] }
  end

  def boleto_params
    params.require('boleto_account').permit(:bank_code, :agency_number, :bank_account)
  end

  def set_company
    @company = Company.find_by(token: params[:company_token])
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    redirect_to root_path unless @payment_method.boleto?
  end

  def set_boleto_account
    @boleto_account = BoletoAccount.find(params[:id])
  end
end
