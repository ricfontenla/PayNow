require 'rails_helper'

describe 'admin approves order' do
  it 'and cannot change status again' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    final_customer = FinalCustomer.create!(name: 'Fulano Sicrano',
                                           cpf: '54321012345')
    CompanyFinalCustomer.create!(company: company,
                                 final_customer: final_customer)
    product = Product.create!(name: 'Curso Ruby Básico',
                              price: 100,
                              pix_discount: 10,
                              card_discount: 0,
                              boleto_discount: 5,
                              company: company)
    order = Order.create!(original_price: 100.0,
                          final_price: 95.0,
                          choosen_payment: 'boleto',
                          adress: 'fulano_sicrano@gmail.com',
                          company: company,
                          status: 'aprovado',
                          final_customer: final_customer,
                          product: product)

    admin_login
    put admin_company_order_path(company, order)

    expect(response).to redirect_to(root_path)
  end
end
