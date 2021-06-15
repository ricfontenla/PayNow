require 'rails_helper'

describe 'Admin manages order status' do
  it 'and save information in the order history' do
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
                               price:100,
                               pix_discount: 10,
                               card_discount: 0,
                               boleto_discount: 5, 
                               company: company)
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                 billing_fee: 2.5, 
                                 max_fee: 100.0,
                                 status: true,
                                 category: :boleto)
    BoletoAccount.create!(bank_code:  479,
                          agency_number:  1234,
                          bank_account: 123456789,
                          company: company,
                          payment_method: boleto)
    order = Order.create!(original_price: 100.0, 
                          final_price: 95.0, 
                          choosen_payment: "boleto",
                          adress: "fulano_sicrano@gmail.com", 
                          company: company, 
                          final_customer: final_customer, 
                          product: product)
    OrderHistory.create!(order: order)

    admin_login
    visit admin_company_order_path(company, order)
    click_on 'Atualizar status de cobrança'
    select 'Aprovado', from: 'Status'
    select '05 - Cobrança efetivada com sucesso', from: 'Código de status'
    click_on 'Enviar'

    expect(page).to have_content('01 - Pendente de cobrança')
    expect(page).to have_content(I18n.l(OrderHistory.first.created_at, format: :long))
    expect(page).to have_content('Pendente')
    expect(page).to have_content('05 - Cobrança efetivada com sucesso')
    expect(page).to have_content(I18n.l(OrderHistory.last.created_at, format: :long))
    expect(page).to have_content('Aprovado', count: 2)
    expect(Receipt.count).to eq(1)
  end

  it 'and cannot change status if already approved' do
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
                               price:100,
                               pix_discount: 10,
                               card_discount: 0,
                               boleto_discount: 5, 
                               company: company)
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                 billing_fee: 2.5, 
                                 max_fee: 100.0,
                                 status: true,
                                 category: :boleto)
    BoletoAccount.create!(bank_code:  479,
                          agency_number:  1234,
                          bank_account: 123456789,
                          company: company,
                          payment_method: boleto)
    order = Order.create!(original_price: 100.0, 
                          final_price: 95.0, 
                          choosen_payment: "boleto",
                          adress: "fulano_sicrano@gmail.com", 
                          company: company, 
                          final_customer: final_customer, 
                          product: product,
                          status: 'aprovado')
    OrderHistory.create!(order: order,
                         status: 'aprovado',
                         response_code: '05 - Cobrança efetivada com sucesso')
    Receipt.create!(order: order)

    admin_login
    visit admin_company_order_path(company, order)
    
    expect(page).to_not have_content('Atualizar status de cobrança')
  end
end