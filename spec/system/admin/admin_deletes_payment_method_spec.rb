require 'rails_helper'

describe 'Admin deletes payment method' do
  it 'sucessfully' do
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                   billing_fee: 2.5, 
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)
    boleto.category_icon
            .attach(io: File.open(Rails.root.join('app/assets/images/icons/boleto.png')), 
                    filename: 'boleto.png')

    admin_login
    visit admin_payment_method_path(boleto)
    
    expect { click_on 'Deletar' }.to change { PaymentMethod.count }.by(-1)
    expect(current_path).to eq(admin_payment_methods_path)
    expect(page).to have_content('apagado com sucesso')
  end
end