require 'rails_helper'

describe 'use tries to register' do
  context 'boleto account' do
    it 'with different payment method' do
      boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                     billing_fee: 2.5, 
                                     max_fee: 100.0,
                                     status: true,
                                     category: :boleto)
      card = PaymentMethod.create!(name: 'PISA', 
                                   billing_fee: 5, 
                                   max_fee: 250,
                                   status: false,
                                   category: 2)
      company = Company.create!(email_domain: 'codeplay.com.br', 
                                cnpj: '00000000000000', 
                                name: 'Codeplay Cursos SA', 
                                billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                                billing_email: 'financas@codeplay.com.br',
                                token: SecureRandom.base58(20))
      BoletoAccount.create!(bank_code:  479,
                            agency_number:  1234,
                            bank_account: 123456789,
                            company: company,
                            payment_method: boleto)
      user = User.create!(email: 'jane_doe@codeplay.com.br', 
                          password: '123456', 
                          role: 0,
                          company: company)

      login_as user, scope: :user
      post user_company_payment_method_boleto_accounts_path(company.token, card.id)

      expect(response).to redirect_to(root_path)
    end
  end
end