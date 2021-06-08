require 'rails_helper'

describe 'user views his company details' do
  it 'as customer admin successfully' do
    company = Company.create!(email_domain: 'codeplay.com.br', 
                             cnpj: '00000000000000', 
                             name: 'Codeplay Cursos SA', 
                             billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                             billing_email: 'financas@codeplay.com.br',
                             token: SecureRandom.base58(20))
    customer_admin = User.create!(email: 'john_doe@codeplay.com.br', 
                                  password: '123456',
                                  role: 10,
                                  company: company)

    login_as customer_admin, scope: :user
    visit root_path
    click_on 'Minha Empresa'

    expect(current_path).to eq(user_company_path(company.token))
    expect(page).to have_content('codeplay.com.br')
    expect(page).to have_content('00000000000000')
    expect(page).to have_content('Codeplay Cursos SA')
    expect(page).to have_content('Rua banana, numero 00 - Bairro Laranja, 00000-000')
    expect(page).to have_content('financas@codeplay.com.br')
    expect(page).to have_content(company.token)
  end
end