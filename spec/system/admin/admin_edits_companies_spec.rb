require 'rails_helper'

describe 'admin edits company' do
  it 'sucessfully' do
    Company.create!(email_domain: 'codeplay.com.br', 
                    cnpj: '00000000000000', 
                    name: 'Codeplay SA', 
                    billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                    billing_email: 'financas@codeplay.com.br',
                    token: SecureRandom.base58(20))

    admin_login
    visit root_path
    click_on 'Clientes'
    click_on 'Codeplay SA'
    click_on 'Atualizar dados'
    fill_in 'Nome', with: 'Codeplay Cursos SA'
    fill_in 'CNPJ', with: '12345678987654'
    fill_in 'Endereço de cobrança', with: 'Rua Batata Palha, número 9 - Bairro Strogonoff, 99999-777'
    fill_in 'Email de cobrança', with: 'cobrancas@codeplay.com.br'
    click_on 'Atualizar Dados'

    expect(current_path).to eq(admin_company_path(Company.last))
    expect(page).to have_content('atualizado com sucesso')
    expect(page).to have_content('Codeplay Cursos SA')
    expect(page).to have_content('@codeplay.com.br')
    expect(page).to have_content('12345678987654')
    expect(page).to have_content('Rua Batata Palha, número 9 - Bairro Strogonoff, 99999-777')
    expect(page).to have_content('cobrancas@codeplay.com.br')
    expect(page).to have_content(Company.last.token)
  end

  it 'and generates a new token' do
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br',
                              token: SecureRandom.base58(20))
    first_token = company.token
    
    admin_login
    visit admin_company_path(company)
    click_on 'Gerar novo token'

    expect(current_path).to eq(admin_company_path(company))
    expect(page).to have_content('Novo token gerado com sucesso')
    expect(page).to have_content(Company.last.token)
    expect(Company.last.token).to_not eq(first_token)
  end

  it 'and fields cannot be blank' do
    Company.create!(email_domain: 'codeplay.com.br', 
                    cnpj: '00000000000000', 
                    name: 'Codeplay SA', 
                    billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                    billing_email: 'financas@codeplay.com.br',
                    token: SecureRandom.base58(20))

    admin_login
    visit edit_admin_company_path(Company.last)
    fill_in 'Nome', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço de cobrança', with: ''
    fill_in 'Email de cobrança', with: ''
    click_on 'Atualizar Dados'

    expect(page).to have_content('não pode ficar em branco', count: 4)
    expect(page).to have_link('Cancelar', href: admin_company_path(Company.last))
  end

  it 'and fields must be unique' do
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
    visit edit_admin_company_path(company)
    fill_in 'Nome', with: 'Cookbook LTDA'
    fill_in 'CNPJ', with: '99999999999999'
    fill_in 'Endereço de cobrança', with: 'Rua Cereja, numero 99 - Bairro Limão, 11111-111'
    fill_in 'Email de cobrança', with: 'financas@cookbook.com.br'
    click_on 'Atualizar Dados'

    expect(page).to have_content('já está em uso', count: 4)
  end

  it 'and CNPJ must have 14 characters' do
    Company.create!(email_domain: 'codeplay.com.br', 
                    cnpj: '00000000000000', 
                    name: 'Codeplay SA', 
                    billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                    billing_email: 'financas@codeplay.com.br',
                    token: SecureRandom.base58(20))

    admin_login
    visit edit_admin_company_path(Company.last)
    fill_in 'CNPJ', with: '1'
    click_on 'Atualizar Dados'

    expect(page).to have_content('não possui o tamanho esperado')
  end
end