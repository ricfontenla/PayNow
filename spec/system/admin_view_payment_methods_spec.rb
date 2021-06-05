require 'rails_helper'

describe "Admin view payment methods" do
  it 'sucessfully' do
    Payment_Method.new(name: 'Boleto', 
                       billing_fee: 2.5, 
                       max_fee: 100,
                       active: True)

    admin_login
    visit root_path
    click_on 'Métodos de Pagamentos'

    expect(page).to have_content('Gerenciar Métodos de Pagamentos')
    expect(page).to have_content('Boleto')
    expect(page).to have_content('2,5 %')
    expect(page).to have_content('R$ 100,00')
  end
end
