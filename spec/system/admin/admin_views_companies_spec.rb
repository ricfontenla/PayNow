require 'rails_helper'

describe 'Admin views companies' do
  it 'sucessfully' do
    Company.create!(email_domain: 'codeplay.com.br', 
                    cnpj: '00000000000000', 
                    name: 'Codeplay Cursos SA', 
                    billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                    billing_email: 'financas@codeplay.com.br',
                    token: SecureRandom.base58(20))
    Company.create!(email_domain: 'cookbook.com.br', 
                    cnpj: '99999999999999', 
                    name: 'Cookbook LTDA', 
                    billing_adress: 'Rua Cereja, numero 99 - Bairro Limão, 11111-111',
                    billing_email: 'financas@cookbook.com.br', 
                    token: SecureRandom.base58(20))
    
    admin_login
    visit root_path
    click_on 'Clientes'
    expect(page).to have_content('Codeplay Cursos SA')
    expect(page).to have_content('codeplay.com.br')
    expect(page).to have_content('Cookbook LTDA')
    expect(page).to have_content('cookbook.com.br')
  end

  it 'and no clients registered' do
    admin_login
    visit admin_companies_path

    expect(page).to have_content('Nenhum cliente cadastrado')
  end

  it 'and view details' do
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br',
                              token: SecureRandom.base58(20))
    Company.create!(email_domain: 'cookbook.com.br', 
                    cnpj: '99999999999999', 
                    name: 'Cookbook LTDA', 
                    billing_adress: 'Rua Cereja, numero 99 - Bairro Limão, 11111-111',
                    billing_email: 'financas@cookbook.com.br', 
                    token: SecureRandom.base58(20))

    admin_login
    visit admin_companies_path
    click_on 'Codeplay Cursos SA'

    expect(page).to have_content('Codeplay Cursos SA')
    expect(page).to have_content('codeplay.com.br')
    expect(page).to have_content('00000000000000')
    expect(page).to have_content('Rua banana, numero 00 - Bairro Laranja, 00000-000')
    expect(page).to have_content('financas@codeplay.com.br')
    expect(page).to have_content(company.token)
    expect(page).to have_link('Voltar', href: admin_companies_path)
    expect(current_path).to eq(admin_company_path(company))
  end
end