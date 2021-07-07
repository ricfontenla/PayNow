require 'rails_helper'

describe 'User edits company' do
  it 'successfully' do
    user_customer_admin_login

    visit root_path
    click_on 'Minha Empresa'
    click_on 'Atualizar dados'
    fill_in 'Endereço de cobrança', with: 'Rua Abacaxi, numero 11 - Bairro Maça, 55555-555'
    fill_in 'Email de cobrança', with: 'cobrancas@paynow.com.br'
    click_on 'Atualizar'

    expect(page).to have_content('Codeplay Cursos SA')
    expect(page).to have_content('codeplay.com.br')
    expect(page).to have_content('00000000000000')
    expect(page).to have_content('Rua Abacaxi, numero 11 - Bairro Maça, 55555-555')
    expect(page).to have_content('cobrancas@paynow.com.br')
    expect(page).to have_content(Company.last.token)
    expect(page).to have_content('atualizado com sucesso')
  end

  it 'and generates a new token' do
    user_customer_admin_login
    visit user_company_path(Company.last.token)

    expect { click_on 'Gerar novo token' }.to(change { Company.last.token })
    expect(current_path).to eq(user_company_path(Company.last.token))
    expect(page).to have_content('Novo token gerado com sucesso')
    expect(page).to have_content(Company.last.token)
    expect(Company.last.company_histories.last.token).to eq(Company.last.token)
  end

  it 'and fields cannot be blank' do
    user_customer_admin_login
    visit edit_user_company_path(Company.last.token)
    fill_in 'Endereço de cobrança', with: ''
    fill_in 'Email de cobrança', with: ''
    click_on 'Atualizar Dados'

    expect(page).to have_content('não pode ficar em branco', count: 2)
    expect(page).to have_link('Cancelar', href: user_company_path(Company.last.token))
  end

  it 'and fields must be unique' do
    Company.create!(email_domain: 'cookbook.com.br',
                    cnpj: '99999999999999',
                    name: 'Cookbook LTDA',
                    billing_adress: 'Rua Cereja, numero 99 - Bairro Limão, 11111-111',
                    billing_email: 'financas@cookbook.com.br')

    user_customer_admin_login
    visit edit_user_company_path(Company.last.token)
    fill_in 'Endereço de cobrança', with: 'Rua Cereja, numero 99 - Bairro Limão, 11111-111'
    fill_in 'Email de cobrança', with: 'financas@cookbook.com.br'
    click_on 'Atualizar Dados'

    expect(page).to have_content('já está em uso', count: 2)
  end

  it 'and fails if is not a customer admin' do
    user_customer_login
    visit user_company_path(Company.last.token)

    expect(page).to_not have_content('Gerar novo token')
    expect(page).to_not have_content('Atualizar dados')
  end

  it 'and generates a new company history' do
    user_customer_admin_login

    visit root_path
    click_on 'Minha Empresa'
    click_on 'Atualizar dados'
    fill_in 'Endereço de cobrança', with: 'Rua Abacaxi, numero 11 - Bairro Maça, 55555-555'
    fill_in 'Email de cobrança', with: 'cobrancas@paynow.com.br'
    click_on 'Atualizar'

    expect(Company.last.company_histories.last.name).to eq('Codeplay Cursos SA')
    expect(Company.last.company_histories.last.cnpj).to eq('00000000000000')
    expect(Company.last.company_histories.last.billing_adress).to eq('Rua Abacaxi, numero 11 - Bairro Maça, 55555-555')
    expect(Company.last.company_histories.last.billing_email).to eq('cobrancas@paynow.com.br')
    expect(Company.last.company_histories.last.token).to eq(Company.last.token)
  end
end
