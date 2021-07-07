require 'rails_helper'

describe 'admin views company orders' do
  it 'successfully' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    final_customer = FinalCustomer.create!(name: 'Fulano Sicrano',
                                           cpf: '54321012345')
    CompanyFinalCustomer.create!(company: company,
                                 final_customer: final_customer)
    product1 = Product.create!(name: 'Curso Ruby Básico',
                               price: 100,
                               pix_discount: 10,
                               card_discount: 0,
                               boleto_discount: 5,
                               company: company)
    product2 = Product.create!(name: 'Curso HTML5',
                               price: 75,
                               pix_discount: 10,
                               card_discount: 0,
                               boleto_discount: 5,
                               company: company)
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja',
                                   billing_fee: 2.5,
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)
    BoletoAccount.create!(bank_code: 479,
                          agency_number: 1234,
                          bank_account: 123_456_789,
                          company: company,
                          payment_method: boleto)
    Order.create!(original_price: 100.0,
                  final_price: 95.0,
                  choosen_payment: 'boleto',
                  adress: 'fulano_sicrano@gmail.com',
                  company: company,
                  final_customer: final_customer,
                  product: product1)
    Order.create!(original_price: 75.0,
                  final_price: 71.25,
                  choosen_payment: 'boleto',
                  adress: 'fulano_sicrano@gmail.com',
                  company: company,
                  final_customer: final_customer,
                  product: product2)

    admin_login
    visit root_path
    click_on 'Clientes'
    click_on 'Codeplay Cursos SA'
    click_on 'Consultar Pedidos'

    expect(page).to have_content('Curso Ruby Básico')
    expect(page).to have_content(I18n.l(Order.first.created_at, format: :long))
    expect(page).to have_content(Order.first.token)
    expect(page).to have_content('Curso HTML5')
    expect(page).to have_content(I18n.l(Order.last.created_at, format: :long))
    expect(page).to have_content(Order.last.token)
  end

  it 'and no orders available' do
    Company.create!(email_domain: 'codeplay.com.br',
                    cnpj: '00000000000000',
                    name: 'Codeplay Cursos SA',
                    billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                    billing_email: 'financas@codeplay.com.br')

    admin_login
    visit root_path
    click_on 'Clientes'
    click_on 'Codeplay Cursos SA'
    click_on 'Consultar Pedidos'

    expect(page).to have_content('Nenhum pedido disponível')
  end

  it 'and view details of order via boleto' do
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
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja',
                                   billing_fee: 2.5,
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)
    BoletoAccount.create!(bank_code: 479,
                          agency_number: 1234,
                          bank_account: 123_456_789,
                          company: company,
                          payment_method: boleto)
    Order.create!(original_price: 100.0,
                  final_price: 95.0,
                  choosen_payment: 'boleto',
                  adress: 'fulano_sicrano@gmail.com',
                  company: company,
                  final_customer: final_customer,
                  product: product)

    admin_login
    visit admin_company_orders_path(company)
    click_on 'Curso Ruby Básico'

    expect(page).to have_content('Curso Ruby Básico')
    expect(page).to have_content('Fulano Sicrano')
    expect(page).to have_content('54321012345')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('R$ 95,00')
    expect(page).to have_content('Boleto')
    expect(page).to have_content('fulano_sicrano@gmail.com')
    expect(page).to have_content(I18n.l(Order.last.created_at, format: :long))
    expect(page).to have_content('Pendente')
  end

  it 'and view details of order via cartão' do
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
    card = PaymentMethod.create!(name: 'PISA',
                                 billing_fee: 5,
                                 max_fee: 250,
                                 status: true,
                                 category: 2)
    CardAccount.create!(credit_code: '9876543210ABCDEfghij',
                        company: company,
                        payment_method: card)
    Order.create!(original_price: 100.0,
                  final_price: 100.0,
                  choosen_payment: 'card',
                  card_number: '9876543210123456',
                  printed_name: 'Fulano Sicrano',
                  verification_code: '000',
                  company: company,
                  final_customer: final_customer,
                  product: product)

    admin_login
    visit admin_company_orders_path(company)
    click_on 'Curso Ruby Básico'

    expect(page).to have_content('Curso Ruby Básico')
    expect(page).to have_content('Fulano Sicrano')
    expect(page).to have_content('54321012345')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('Cartão')
    expect(page).to have_content('9876543210123456')
    expect(page).to have_content('Fulano Sicrano')
    expect(page).to have_content('000')
    expect(page).to have_content(I18n.l(Order.last.created_at, format: :long))
    expect(page).to have_content('Pendente')
  end

  it 'and view details of order via pix' do
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
    pix = PaymentMethod.create!(name: 'PIX Banco Roxinho',
                                billing_fee: 1,
                                max_fee: 250,
                                status: true,
                                category: 3)
    PixAccount.create!(pix_key: '12345abcde67890FGHIJ',
                       bank_code: '001',
                       company: company,
                       payment_method: pix)
    Order.create!(original_price: 100.0,
                  final_price: 90.0,
                  choosen_payment: 'pix',
                  company: company,
                  final_customer: final_customer,
                  product: product)

    admin_login
    visit admin_company_orders_path(company)
    click_on 'Curso Ruby Básico'

    expect(page).to have_content('Curso Ruby Básico')
    expect(page).to have_content('Fulano Sicrano')
    expect(page).to have_content('54321012345')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('R$ 90,00')
    expect(page).to have_content('PIX')
    expect(page).to have_content(I18n.l(Order.last.created_at, format: :long))
    expect(page).to have_content('Pendente')
  end
end
