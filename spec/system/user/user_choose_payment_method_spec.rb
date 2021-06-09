require 'rails_helper'

xdescribe 'User choose payment method' do
  context 'boleto' do
    it 'and registers it successfully' do
      boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                               billing_fee: 2.5, 
                               max_fee: 100.0,
                               status: true,
                               category: :boleto)
      boleto.category_icon
              .attach(io: File.open(Rails.root.join('app/assets/images/icons/boleto.png')), 
                      filename: 'boleto.png')

      user_customer_admin_login
      visit root_path
      click_on 'Minha Empresa'
      click_on 'Novo Método de Pagamento'
      click_on 'Boleto do Banco Laranja'
      click_on 'Cadastrar Dados '
    end
  end
end