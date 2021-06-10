require 'csv'

class User::BoletoAccountsController < User::UserController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @company = Company.find_by(token: params[:company_token])
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    @boleto_account = BoletoAccount.new
    @bank_codes = bank_codes
  end

  def create
    @company = Company.find_by(token: params[:company_token])
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    @boleto_account = @company.boleto_accounts.build(boleto_params)
    @boleto_account.payment_method_id = @payment_method.id
    if @boleto_account.save
      redirect_to my_payment_methods_user_company_path(@company.token, @boleto_account)
    else
      @bank_codes = bank_codes
      render :new
    end
  end

  def edit
    @company = Company.find_by(token: params[:company_token])
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    @boleto_account = BoletoAccount.find(params[:id])
    @bank_codes = bank_codes
  end

  def update
    @company = Company.find_by(token: params[:company_token])
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    @boleto_account = BoletoAccount.find(params[:id])
    if @boleto_account.update(boleto_params)
      flash[:notice] = t('.success')
      redirect_to my_payment_methods_user_company_path(@company.token, @boleto_account)
    else
      @bank_codes = bank_codes
      render :edit
    end
  end

  def destroy
    @company = Company.find_by(token: params[:company_token])
    @boleto_account = BoletoAccount.find(params[:id])
    @boleto_account.destroy
    flash[:notice] = t('.success')
    redirect_to my_payment_methods_user_company_path(@company.token)
  end

  private
  def bank_codes
    csv = File.read(Rails.root.join('lib/assets/csv/bancos_associados.csv'))
    CSV.parse(csv).map { |key, value| [key + ' - ' + value, key] }
  end

  private
  def boleto_params
    params.require('boleto_account').permit(:bank_code, :agency_number, :bank_account)
  end
end