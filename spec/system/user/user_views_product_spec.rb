require 'rails_helper'

describe 'user views product' do
  it 'successfully' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    user = User.create!(email: 'jane_doe@codeplay.com.br',
                        password: '123456',
                        role: 0,
                        company: company)
    Product.create!(name: 'Curso Ruby Básico',
                    price: '100',
                    pix_discount: 10,
                    card_discount: 0,
                    boleto_discount: 5,
                    company: company)
    Product.create!(name: 'Curso HTML5',
                    price: '60',
                    pix_discount: 8.5,
                    card_discount: 0,
                    boleto_discount: 3.25,
                    company: company)

    login_as user, scope: :user
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Meus Produtos'

    expect(current_path).to eq(user_company_products_path(Company.last.token))
    expect(page).to have_content('Curso Ruby Básico')
    expect(page).to have_content('Curso HTML5')
  end

  it 'and no products registered' do
    user_customer_admin_login
    visit user_company_products_path(Company.last.token)

    expect(page).to have_content('Nenhum produto disponível')
  end

  it 'and view details' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    user = User.create!(email: 'jane_doe@codeplay.com.br',
                        password: '123456',
                        role: 0,
                        company: company)
    Product.create!(name: 'Curso Ruby Básico',
                    price: '100',
                    pix_discount: 10,
                    card_discount: 0,
                    boleto_discount: 5,
                    company: company)

    login_as user, scope: :user
    visit user_company_products_path(company.token)
    click_on 'Curso Ruby Básico'

    expect(current_path).to eq(user_company_product_path(company.token, Product.first.id))
    expect(page).to have_content('Curso Ruby Básico')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('0,00%')
    expect(page).to have_content('5,00%')
    expect(page).to have_content(Product.last.token)
  end
end
