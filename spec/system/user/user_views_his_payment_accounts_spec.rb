require 'rails_helper'

describe 'user views his payment accounts' do
  it 'successfully' do
    company = Company.create!(email_domain: 'codeplay.com.br', 
                          cnpj: '00000000000000', 
                          name: 'Codeplay Cursos SA', 
                          billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                          billing_email: 'financas@codeplay.com.br',
                          token: SecureRandom.base58(20))
                          
    user =  User.create!(email: 'john_doe@codeplay.com.br', 
                         password: '123456',
                         role: 10,
                         company: company)

    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                   billing_fee: 2.5, 
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)
    BoletoAccount.create!(bank_code:  479,
                          agency_number:  1234,
                          bank_account: 123456789,
                          company: company,
                          payment_method: boleto)

    login_as user, scope: :user
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Meus Métodos de Pagamento'

    expect(page).to have_content('Boleto do Banco Laranja')
    expect(page).to have_content('479')
    expect(page).to have_content('1234')
    expect(page).to have_content('123456789')
  end

  it 'and no accounts registered' do
    user_customer_admin_login
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Meus Métodos de Pagamento'

    expect(page).to have_content('Nenhum dado para recebimento via boletos cadastrado')
  end
end
