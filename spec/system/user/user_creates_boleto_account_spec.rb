require 'rails_helper'

describe 'user creates boleto account' do
  it 'and registers it successfully' do
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                   billing_fee: 2.5, 
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)

    user_customer_admin_login
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Novo Método de Pagamento'
    click_on 'Boleto do Banco Laranja'
    click_on 'Cadastrar Dados Para Boleto'
    select '479 - Banco ItauBank S.A', from: 'Código do banco'
    fill_in 'Número da agência', with: '0000'
    fill_in 'Conta bancária', with: '000000000'
    click_on 'Enviar'

    expect(page).to have_content('Boleto do Banco Laranja')
    expect(page).to have_content('479')
    expect(page).to have_content('0000')
    expect(page).to have_content('000000000')
  end

  it 'and fields cannot be blank' do
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                   billing_fee: 2.5, 
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)

    user_customer_admin_login
    visit new_user_company_payment_method_boleto_account_path(Company.last.token, boleto.id)
    click_on 'Enviar'

    expect(page).to have_content('não pode ficar em branco', count: 3)
    expect(page).to have_content('não possui o tamanho esperado', count: 2)
  end

  it 'and must be unique' do
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                   billing_fee: 2.5, 
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)
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
    visit new_user_company_payment_method_boleto_account_path(Company.last.token, boleto.id)
    select '479 - Banco ItauBank S.A', from: 'Código do banco'
    fill_in 'Número da agência', with: '1234'
    fill_in 'Conta bancária', with: '123456789'
    click_on 'Enviar'

    expect(page).to have_content('já está em uso', count: 1)
  end

  it 'and cannot register a boleto account in a different payment method' do
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
    visit new_user_company_payment_method_boleto_account_path(Company.last.token, card.id)
    
    expect(current_path).to eq(root_path)
  end
end