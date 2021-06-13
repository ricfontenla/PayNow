require 'rails_helper'

describe 'User edits boleto account' do
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
    BoletoAccount.create!(bank_code:  479,
                          agency_number:  1234,
                          bank_account: 123456789,
                          company: company,
                          payment_method: boleto)
                          
    login_as user, scope: :user
    visit user_company_path(company.token)
    click_on 'Meus Métodos de Pagamento'
    click_on 'Editar'
    select '184 - Banco Itaú BBA S.A.', from: 'Código do banco'
    fill_in 'Número da agência',	with: '4321'
    fill_in 'Conta bancária', with: '987654321'
    click_on 'Enviar'

    expect(page).to have_content('Boleto do Banco Laranja')
    expect(page).to have_content('184')
    expect(page).to have_content('4321')
    expect(page).to have_content('987654321')
    expect(page).to have_content('Dados para boleto atualizados com sucesso')
  end

  it 'and fields cannot be blank' do
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
    BoletoAccount.create!(bank_code:  479,
                          agency_number:  1234,
                          bank_account: 123456789,
                          company: company,
                          payment_method: boleto)

    login_as user, scope: :user
    visit edit_user_company_payment_method_boleto_account_path(company.token, boleto, BoletoAccount.last.id)
    select '', from: 'Código do banco'
    fill_in 'Número da agência',	with: ''
    fill_in 'Conta bancária', with: ''
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
                              billing_email: 'financas@codeplay.com.br')
    BoletoAccount.create!(bank_code:  184,
                          agency_number:  4321,
                          bank_account: 987654321,
                          company: company,
                          payment_method: boleto)
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
    visit edit_user_company_payment_method_boleto_account_path(Company.last.token, boleto.id, BoletoAccount.last.id)
     select '184 - Banco Itaú BBA S.A.', from: 'Código do banco'
    fill_in 'Número da agência',	with: '4321'
    fill_in 'Conta bancária', with: '987654321'
    click_on 'Enviar'

    expect(page).to have_content('já está em uso')
  end
end