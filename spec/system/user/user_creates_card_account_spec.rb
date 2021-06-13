require 'rails_helper'

describe 'user creates card account' do
  it 'and registers it successfully' do
    PaymentMethod.create!(name: 'PISA', 
                          billing_fee: 5, 
                          max_fee: 250,
                          status: true,
                          category: 2)
    
    user_customer_admin_login
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Novo Método de Pagamento'
    click_on 'PISA'
    click_on 'Cadastrar Dados Para Cartão'
    fill_in 'Conta referente a operadora do cartão', with: '9876543210ABCDEfghij'
    click_on 'Enviar'

    expect(page).to have_content('PISA')
    expect(page).to have_content('9876543210ABCDEfghij')
  end

  it 'and fields cannot be blank' do
    card = PaymentMethod.create!(name: 'PISA', 
                                 billing_fee: 5, 
                                 max_fee: 250,
                                 status: true,
                                 category: 2)

    user_customer_admin_login
    visit new_user_company_payment_method_card_account_path(Company.last.token, card.id)
    click_on 'Enviar'

    expect(page).to have_content('não pode ficar em branco')
    expect(page).to have_content('não possui o tamanho esperado')
    expect(page).to have_content('não é válido')
  end

  it 'and must be unique' do
    card = PaymentMethod.create!(name: 'PISA', 
                                 billing_fee: 5, 
                                 max_fee: 250,
                                 status: true,
                                 category: 2)
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    CardAccount.create!(credit_code: '9876543210ABCDEfghij',
                        company: company,
                        payment_method: card)
    user = User.create!(email: 'jane_doe@codeplay.com.br', 
                        password: '123456', 
                        role: 0,
                        company: company)

    login_as user, scope: :user
    visit new_user_company_payment_method_card_account_path(Company.last.token, card.id)
    fill_in 'Conta referente a operadora do cartão', with: '9876543210ABCDEfghij'
    click_on 'Enviar'

    expect(page).to have_content('já está em uso')
  end

  it 'and cannot register a card account in a different payment method' do
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                   billing_fee: 2.5, 
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    user = User.create!(email: 'jane_doe@codeplay.com.br', 
                        password: '123456', 
                        role: 0,
                        company: company)

    login_as user, scope: :user
    visit new_user_company_payment_method_card_account_path(Company.last.token, boleto.id)
    
    expect(current_path).to eq(root_path)
  end
end