require 'rails_helper'

describe 'User edits card account' do
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
    card = PaymentMethod.create!(name: 'PISA', 
                                 billing_fee: 5, 
                                 max_fee: 250,
                                 status: true,
                                 category: 2)
    CardAccount.create!(credit_code:  '9876543210ABCDEfghij',
                        company: company,
                        payment_method: card)
                          
    login_as user, scope: :user
    visit user_company_path(company.token)
    click_on 'Meus Métodos de Pagamento'
    click_on 'Editar'
    fill_in 'Conta referente a operadora do cartão', with: 'ABCDEfghij9876543210'
    click_on 'Enviar'

    expect(page).to have_content('PISA')
    expect(page).to have_content('ABCDEfghij9876543210')
    expect(page).to have_content('Dados para cartão atualizados com sucesso')
  end

  it 'and fields cannot be blank' do
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
    card = PaymentMethod.create!(name: 'PISA', 
                                 billing_fee: 5, 
                                 max_fee: 250,
                                 status: true,
                                 category: 2)
    CardAccount.create!(credit_code:  '9876543210ABCDEfghij',
                        company: company,
                        payment_method: card)

    login_as user, scope: :user
    visit edit_user_company_payment_method_card_account_path(company.token, card, CardAccount.last.id)
    fill_in 'Conta referente a operadora do cartão', with: ''
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
                              billing_email: 'financas@codeplay.com.br',
                              token: SecureRandom.base58(20))
    CardAccount.create!(credit_code: '9876543210ABCDEfghij',
                        company: company,
                        payment_method: card)
    CardAccount.create!(credit_code: '1234567890zxcvbNMASD',
                        company: company,
                        payment_method: card)
    user = User.create!(email: 'jane_doe@codeplay.com.br', 
                        password: '123456', 
                        role: 0,
                        company: company)

    login_as user, scope: :user
    visit edit_user_company_payment_method_card_account_path(Company.last.token, card.id, CardAccount.last.id)
    fill_in 'Conta referente a operadora do cartão', with: '9876543210ABCDEfghij'
    click_on 'Enviar'

    expect(page).to have_content('já está em uso', count: 1)
  end
end