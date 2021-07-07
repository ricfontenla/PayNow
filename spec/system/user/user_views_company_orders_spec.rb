require 'rails_helper'

describe 'User views his company orders' do
  context 'of last 30 days' do
    it 'successfully' do
      company = Company.create!(email_domain: 'codeplay.com.br',
                                cnpj: '00000000000000',
                                name: 'Codeplay Cursos SA',
                                billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                                billing_email: 'financas@codeplay.com.br')
      customer_admin = User.create!(email: 'john_doe@codeplay.com.br',
                                    password: '123456',
                                    role: 10,
                                    company: company)
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
      order = Order.create!(original_price: 100.0,
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
                    product: product2,
                    created_at: 2.months.ago)
      Order.create!(original_price: 75.0,
                    final_price: 71.25,
                    choosen_payment: 'boleto',
                    adress: 'fulano_sicrano@gmail.com',
                    company: company,
                    final_customer: final_customer,
                    product: product2,
                    created_at: 6.months.ago)

      login_as customer_admin, scope: :user
      visit root_path
      click_on 'Minha Empresa'
      click_on 'Minhas Vendas'

      expect(page).to have_content(order.product.name)
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('R$ 95,00')
      expect(page).to have_content('boleto')
      expect(page).to have_content(order.status)
      expect(page).to have_content(I18n.l(order.created_at, format: :long))
      expect(page).to_not have_content(product2.name)
      expect(page).to_not have_content('R$ 75,00')
      expect(page).to_not have_content('R$ 71,25')
    end
  end

  context 'of last 90 days' do
    it 'successfully' do
      company = Company.create!(email_domain: 'codeplay.com.br',
                                cnpj: '00000000000000',
                                name: 'Codeplay Cursos SA',
                                billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                                billing_email: 'financas@codeplay.com.br')
      customer_admin = User.create!(email: 'john_doe@codeplay.com.br',
                                    password: '123456',
                                    role: 10,
                                    company: company)
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
      product3 = Product.create!(name: 'Curso Python',
                                 price: 150,
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
                            product: product1)
      order2 = Order.create!(original_price: 75.0,
                             final_price: 71.25,
                             choosen_payment: 'boleto',
                             adress: 'fulano_sicrano@gmail.com',
                             company: company,
                             final_customer: final_customer,
                             product: product2,
                             created_at: 2.months.ago)
      order3 = Order.create!(original_price: 150.0,
                             final_price: 142.5,
                             choosen_payment: 'boleto',
                             adress: 'fulano_sicrano@gmail.com',
                             company: company,
                             final_customer: final_customer,
                             product: product3,
                             created_at: 6.months.ago)

      login_as customer_admin, scope: :user
      visit user_company_orders_path(company.token)
      click_on 'Últimos 90 dias'

      expect(page).to have_content(order.product.name)
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('R$ 95,00')
      expect(page).to have_content('boleto')
      expect(page).to have_content(order.status)
      expect(page).to have_content(I18n.l(order.created_at, format: :long))
      expect(page).to have_content(order2.product.name)
      expect(page).to have_content('R$ 75,00')
      expect(page).to have_content('R$ 71,25')
      expect(page).to have_content(I18n.l(order2.created_at, format: :long))
      expect(page).to_not have_content(product3.name)
      expect(page).to_not have_content('R$ 150,00')
      expect(page).to_not have_content('R$ 142,50')
      expect(page).to_not have_content(I18n.l(order3.created_at, format: :long))
    end
  end

  context 'all of then' do
    it 'successfully' do
      company = Company.create!(email_domain: 'codeplay.com.br',
                                cnpj: '00000000000000',
                                name: 'Codeplay Cursos SA',
                                billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                                billing_email: 'financas@codeplay.com.br')
      customer_admin = User.create!(email: 'john_doe@codeplay.com.br',
                                    password: '123456',
                                    role: 10,
                                    company: company)
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
      product3 = Product.create!(name: 'Curso Python',
                                 price: 150,
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
                            product: product1)
      order2 = Order.create!(original_price: 75.0,
                             final_price: 71.25,
                             choosen_payment: 'boleto',
                             adress: 'fulano_sicrano@gmail.com',
                             company: company,
                             final_customer: final_customer,
                             product: product2,
                             created_at: 2.months.ago)
      order3 = Order.create!(original_price: 150.0,
                             final_price: 142.5,
                             choosen_payment: 'boleto',
                             adress: 'fulano_sicrano@gmail.com',
                             company: company,
                             final_customer: final_customer,
                             product: product3,
                             created_at: 6.months.ago)

      login_as customer_admin, scope: :user
      visit user_company_orders_path(company.token)
      click_on 'Todas'

      expect(page).to have_content(order.product.name)
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('R$ 95,00')
      expect(page).to have_content('boleto')
      expect(page).to have_content(order.status)
      expect(page).to have_content(I18n.l(order.created_at, format: :long))
      expect(page).to have_content(order2.product.name)
      expect(page).to have_content('R$ 75,00')
      expect(page).to have_content('R$ 71,25')
      expect(page).to have_content(I18n.l(order2.created_at, format: :long))
      expect(page).to have_content(product3.name)
      expect(page).to have_content('R$ 150,00')
      expect(page).to have_content('R$ 142,50')
      expect(page).to have_content(I18n.l(order3.created_at, format: :long))
    end
  end

  it 'and no orders in the system' do
    user_customer_admin_login
    visit user_company_orders_path(Company.last.token)

    expect(page).to have_content('Nenhuma venda registrada para este filtro')
  end
end
