require 'rails_helper'

describe 'user edits product' do
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
                    price:100,
                    pix_discount: 10,
                    card_discount: 0,
                    boleto_discount: 5, 
                    company: company)

    login_as user, scope: :user
    visit user_company_product_path(company.token, Product.last.id)
    click_on 'Editar'
    fill_in 'Nome', with: 'Curso de HTML5'
    fill_in 'Preço', with: 75
    fill_in 'Desconto PIX', with: 9.5
    fill_in 'Desconto cartão', with: 1
    fill_in 'Desconto boleto', with: 3.14
    click_on 'Enviar'

    expect(current_path).to eq(user_company_product_path(company.token, Product.last.id))
    expect(page).to have_content('Produto editado com sucesso')
    expect(page).to have_content('Curso de HTML5')
    expect(page).to have_content('R$ 75,00')
    expect(page).to have_content('9,50%')
    expect(page).to have_content('1,00%')
    expect(page).to have_content('3,14%')
  end

  it 'and fields cannot be blank' do
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
                    price:100,
                    pix_discount: 10,
                    card_discount: 0,
                    boleto_discount: 5, 
                    company: company)

    login_as user, scope: :user
    visit user_company_product_path(company.token, Product.last.id)
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Preço', with: ''
    fill_in 'Desconto PIX', with: ''
    fill_in 'Desconto cartão', with: ''
    fill_in 'Desconto boleto', with: ''
    click_on 'Enviar'

    expect(page).to have_content('não pode ficar em branco', count: 5)
    expect(page).to have_content('não é um número', count: 4)
  end

  it 'and must be unique' do
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
                    price: 100,
                    pix_discount: 10,
                    card_discount: 0,
                    boleto_discount: 5, 
                    company: company)
    Product.create!(name: 'Curso HTML5',
                    price: 75,
                    pix_discount: 9,
                    card_discount: 1.5,
                    boleto_discount: 3, 
                    company: company)

    login_as user, scope: :user
    visit user_company_product_path(company.token, Product.last.id)
    click_on 'Editar'
    fill_in 'Nome', with: 'Curso Ruby Básico'
    click_on 'Enviar'

    expect(page).to have_content('já está em uso')
  end
end
