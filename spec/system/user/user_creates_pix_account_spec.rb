require 'rails_helper'

describe 'user creates pix account' do
  it 'and registers it successfully' do
    PaymentMethod.create!(name: 'PIX Banco Roxinho', 
                          billing_fee: 1, 
                          max_fee: 250,
                          status: true,
                          category: 3)
    
    user_customer_admin_login
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Novo Método de Pagamento'
    click_on 'PIX Banco Roxinho'
    click_on 'Cadastrar Dados Para PIX'
    select '104 - Caixa Econômica Federal', from: 'Código do banco'
    fill_in 'Chave PIX', with: '9876543210ABCDEfghij'
    click_on 'Enviar'

    expect(page).to have_content('104')
    expect(page).to have_content('9876543210ABCDEfghij')
  end

  it 'and fields cannot be blank' do
    pix = PaymentMethod.create!(name: 'PIX Banco Roxinho', 
                                billing_fee: 1, 
                                max_fee: 250,
                                status: true,
                                category: 3)

    user_customer_admin_login
    visit new_user_company_payment_method_pix_account_path(Company.last.token, pix.id)
    click_on 'Enviar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
    expect(page).to have_content('não possui o tamanho esperado')
    expect(page).to have_content('não é válido')
  end

  it 'and must be unique' do
    pix = PaymentMethod.create!(name: 'PIX Banco Roxinho', 
                                billing_fee: 1, 
                                max_fee: 250,
                                status: true,
                                category: 3)
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    PixAccount.create!(pix_key: '12345abcde67890FGHIJ',
                       bank_code: '001',
                       company: company,
                       payment_method: pix)
    user = User.create!(email: 'jane_doe@codeplay.com.br', 
                        password: '123456', 
                        role: 0,
                        company: company)

    login_as user, scope: :user
    visit new_user_company_payment_method_pix_account_path(Company.last.token, pix.id)
    select '001 - Banco do Brasil S.A.', from: 'Código do banco'
    fill_in 'Chave PIX', with: '12345abcde67890FGHIJ'
    click_on 'Enviar'

    expect(page).to have_content('já está em uso')
  end

  it 'and cannot register a pix account in a different payment method' do
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
    visit new_user_company_payment_method_pix_account_path(Company.last.token, boleto.id)
    
    expect(current_path).to eq(root_path)
  end
end