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
    card = PaymentMethod.create!(name: 'PISA', 
                                   billing_fee: 3, 
                                   max_fee: 500.0,
                                   status: true,
                                   category: :boleto)
    BoletoAccount.create!(bank_code:  479,
                          agency_number:  1234,
                          bank_account: 123456789,
                          company: company,
                          payment_method: boleto)
    CardAccount.create!(credit_code: '9876543210ABCDEfghij',
                        company: company,
                        payment_method: card)

    login_as user, scope: :user
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Meus Métodos de Pagamento'

    expect(page).to have_content('Boleto do Banco Laranja')
    expect(page).to have_content('479')
    expect(page).to have_content('1234')
    expect(page).to have_content('123456789')
    expect(page).to have_content('PISA')
    expect(page).to have_content('9876543210ABCDEfghij')
  end

  it 'and no accounts registered' do
    user_customer_admin_login
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Meus Métodos de Pagamento'

    expect(page).to have_content('Nenhum dado para recebimento via boletos cadastrado')
    expect(page).to have_content('Nenhum dado para recebimento via cartão cadastrado')
  end
end
