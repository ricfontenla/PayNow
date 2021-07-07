require 'rails_helper'

describe 'user deletes product' do
  it 'sucessfully' do
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
    visit user_company_product_path(company.token, Product.last.id)

    expect { click_on 'Deletar' }.to change { Product.count }.by(-1)
    expect(page).to have_content('Produto deletado com sucesso')
  end
end
