require 'rails_helper'

describe 'Admin views companies' do
  it 'sucessfully' do
    create(:company)
    create(:company, email_domain: 'cookbook.com.br',
                     name: 'Cookbook LTDA',
                     cnpj: '99999999999999')

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
    company = create(:company)
    create(:company, email_domain: 'cookbook.com.br',
                     name: 'Cookbook LTDA',
                     cnpj: '99999999999999')

    admin_login
    visit admin_companies_path
    click_on 'Codeplay Cursos SA'

    expect(page).to have_content('Codeplay Cursos SA')
    expect(page).to have_content('codeplay.com.br')
    expect(page).to have_content('00000000000000')
    expect(page).to have_content('Rua banana, numero 8 - Bairro Laranja, 00000-000')
    expect(page).to have_content('financas8@codeplay.com.br')
    expect(page).to have_content(company.token)
    expect(page).to have_link('Voltar', href: admin_companies_path)
    expect(current_path).to eq(admin_company_path(company))
  end
end
