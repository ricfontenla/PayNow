require 'rails_helper'

describe 'Visitor views his receipt' do
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
    order = Order.create!(original_price: 100.0,
                          final_price: 95.0,
                          choosen_payment: 'boleto',
                          adress: 'fulano_sicrano@gmail.com',
                          company: company,
                          final_customer: final_customer,
                          product: product,
                          status: 'aprovado')
    OrderHistory.create!(order: order,
                         status: 'aprovado',
                         response_code: '05 - Cobrança efetivada com sucesso')
    Receipt.create!(order: order)

    visit receipt_path(Receipt.last.token)

    expect(page).to have_content('Codeplay Cursos SA')
    expect(page).to have_content('00000000000000')
    expect(page).to have_content('Rua banana, numero 00 - Bairro Laranja, 00000-000')
    expect(page).to have_content('Fulano Sicrano')
    expect(page).to have_content('54321012345')
    expect(page).to have_content('Curso Ruby Básico')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('R$ 95,00')
    expect(page).to have_content('Boleto')
    expect(page).to have_content(I18n.l(OrderHistory.first.created_at.to_date.next_month))
    expect(page).to have_content(I18n.l(OrderHistory.first.created_at, format: :long))
    expect(page).to have_content(Receipt.last.token)
  end
end
