require 'rails_helper'

describe 'user deletes card account' do
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
    CardAccount.create!(credit_code: '9876543210ABCDEfghij',
                        company: company,
                        payment_method: card)

    login_as user, scope: :user
    visit my_payment_methods_user_company_path(company.token)
    click_on 'Deletar'

    expect(page).to have_content('apagados com sucesso')
    expect(page).to have_content('Nenhum dado para recebimento via cartão cadastrado')
    expect(page).to_not have_content('PISA')
    expect(page).to_not have_content('9876543210ABCDEfghij')
  end
end