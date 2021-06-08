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
boleto.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/boleto.png')), 
                filename: 'boleto.png')

card = PaymentMethod.create!(name: 'PISA', 
                             billing_fee: 5, 
                             max_fee: 250,
                             status: false,
                             category: 2)
card.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/card.png')), 
                filename: 'card.png')

pix = PaymentMethod.create!(name: 'PIX Banco Roxinho', 
                            billing_fee: 1, 
                            max_fee: 250,
                            status: true,
                            category: 3)
pix.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/pix.png')), 
                filename: 'pix.png')

company = Company.create!(email_domain: 'codeplay.com.br', 
                          cnpj: '00000000000000', 
                          name: 'Codeplay Cursos SA', 
                          billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                          billing_email: 'financas@codeplay.com.br',
                          token: SecureRandom.base58(20))
                          
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
                          billing_email: 'financas@cookbook.com.br', 
                          token: SecureRandom.base58(20))

User.create!(email: 'john_doe4@cookbook.com.br', 
             password: '123456',
             role: 10,
             company: company2)
             
User.create!(email: 'john_doe5@cookbook.com.br', 
             password: '123456',
             role: 0,
             company: company2,
             status: false)