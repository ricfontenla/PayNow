require 'rails_helper'

describe 'User views same company users' do
  it 'sucessfully' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    User.create!(email: 'john_doe@codeplay.com.br',
                 password: '123456',
                 role: 10,
                 company: company)
    User.create!(email: 'john_doe2@codeplay.com.br',
                 password: '123456',
                 role: 0,
                 company: company)
    User.create!(email: 'john_doe3@codeplay.com.br',
                 password: '123456',
                 role: 0,
                 company: company,
                 status: false)

    admin_login
    visit root_path
    click_on 'Clientes'
    click_on 'Codeplay Cursos SA'

    expect(page).to have_content('john_doe@codeplay.com.br')
    expect(page).to have_content('Administrador da Empresa')
    expect(page).to have_content('john_doe2@codeplay.com.br')
    expect(page).to have_content('Funcionário', count: 2)
    expect(page).to have_content('Ativo', count: 2)
    expect(page).to have_content('john_doe3@codeplay.com.br')
    expect(page).to have_content('Inativo')
  end
end
