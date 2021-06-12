require 'rails_helper'

describe 'user creates product' do
  it 'successfully' do
    user_customer_admin_login
    visit user_company_products_path(Company.last.token)
    click_on 'Cadastrar novo Produto'
    fill_in 'Nome', with: 'Curso Ruby'
    fill_in'Preço', with: 100
    fill_in'Desconto PIX', with: 10
    fill_in'Desconto cartão', with: 0
    fill_in'Desconto boleto', with: 5
    click_on 'Enviar'

    expect(page).to have_content('Curso Ruby')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('0,00%')
    expect(page).to have_content('5,00%')
    expect(page).to have_content(Product.last.token)
  end

  it 'and fields cannot be blank' do
    user_customer_admin_login
    visit new_user_company_product_path(Company.last.token)
    click_on 'Enviar'

    expect(page).to have_content('não pode ficar em branco', count: 5)
    expect(page).to have_content('não é um número', count: 4)
  end

  it 'and fields mut be unique' do
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
                    price:'100',
                    pix_discount: 10,
                    card_discount: 0,
                    boleto_discount: 5, 
                    company: company)
    
    login_as user, scope: :user
    visit new_user_company_product_path(Company.last.token)
    fill_in 'Nome', with: 'Curso Ruby Básico'
    fill_in 'Preço', with: 100
    fill_in 'Desconto PIX', with: 10
    fill_in 'Desconto cartão', with: 0
    fill_in 'Desconto boleto', with: 5.5
    click_on 'Enviar'

    expect(page).to have_content('já está em uso')
  end
end
