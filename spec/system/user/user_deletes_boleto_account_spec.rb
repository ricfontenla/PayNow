require 'rails_helper'

describe 'user deletes boleto account' do
  it 'successfully' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    user =  User.create!(email: 'john_doe@codeplay.com.br',
                         password: '123456',
                         role: 10,
                         company: company)
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja',
                                   billing_fee: 2.5,
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)
    BoletoAccount.create!(bank_code: 479,
                          agency_number: 1234,
                          bank_account: 123_456_789,
                          company: company,
                          payment_method: boleto)

    login_as user, scope: :user
    visit my_payment_methods_user_company_path(company.token)
    click_on 'Deletar'

    expect(page).to have_content('apagados com sucesso')
    expect(page).to have_content('Nenhum dado para recebimento via boletos cadastrado')
    expect(page).to_not have_content('Boleto do Banco Laranja')
    expect(page).to_not have_content('479')
    expect(page).to_not have_content('1234')
    expect(page).to_not have_content('123456789')
  end
end
