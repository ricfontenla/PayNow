# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
admin = Admin.create!(email: 'ademir@paynow.com.br', 
                      password: '123456')

boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                               billing_fee: 2.5, 
                               max_fee: 100.0,
                               status: true,
                               category: :boleto)

card = PaymentMethod.create!(name: 'PISA', 
                             billing_fee: 5, 
                             max_fee: 250,
                             status: false,
                             category: 2)

pix = PaymentMethod.create!(name: 'PIX Banco Roxinho', 
                            billing_fee: 1, 
                            max_fee: 250,
                            status: true,
                            category: 3)

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

order = Order.create!(original_price: 100.0, 
                          final_price: 95.0, 
                          choosen_payment: "boleto",
                          adress: "fulano_sicrano@gmail.com", 
                          company: company, 
                          final_customer: final_customer, 
                          product: product)
                          
OrderHistory.create!(order: order)

BoletoAccount.create!(bank_code:  479,
                      agency_number:  1234,
                      bank_account: 123456789,
                      company: company,
                      payment_method: boleto)
                          
User.create!(email: 'john_doe@codeplay.com.br', 
             password: '123456',
             role: 10,
             company: company)
             
User.create!(email: 'john_doe2@codeplay.com.br', 
             password: '123456',
             role: 0,
             company: company,
             status: false)

User.create!(email: 'john_doe3@codeplay.com.br', 
             password: '123456',
             role: 0,
             company: company)

company2 = Company.create!(email_domain: 'cookbook.com.br', 
                          cnpj: '99999999999999', 
                          name: 'Cookbook LTDA', 
                          billing_adress: 'Rua Cereja, numero 99 - Bairro Limão, 11111-111',
                          billing_email: 'financas@cookbook.com.br')

User.create!(email: 'john_doe4@cookbook.com.br', 
             password: '123456',
             role: 10,
             company: company2)
             
User.create!(email: 'john_doe5@cookbook.com.br', 
             password: '123456',
             role: 0,
             company: company2,
             status: false)