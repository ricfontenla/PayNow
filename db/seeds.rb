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