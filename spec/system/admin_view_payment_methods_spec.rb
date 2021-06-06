require 'rails_helper'

describe "Admin view payment methods" do
  it 'sucessfully' do
    PaymentMethod.create!(name: 'Boleto', 
                          billing_fee: 2.5, 
                          max_fee: 100.0,
                          active: true)
    PaymentMethod.create!(name: 'Cartão PISA', 
                          billing_fee: 5, 
                          max_fee: 250,
                          active: false)

    admin_login
    visit root_path
    save_page
    click_on 'Métodos de Pagamento'

    expect(page).to have_content('Gerenciar Métodos de Pagamentos')
    expect(page).to have_content('Boleto')
    expect(page).to have_content('Ativo')
    expect(page).to have_content('Cartão PISA')
    expect(page).to have_content('Inativo')
  end

  it 'and view details' do
    PaymentMethod.create!(name: 'Boleto', 
                          billing_fee: 2.5, 
                          max_fee: 100.0,
                          active: true)
    method = PaymentMethod.create!(name: 'Cartão PISA', 
                                   billing_fee: 5.5, 
                                   max_fee: 250,
                                   active: false)

    admin_login
    visit admin_payment_methods_path
    click_on 'Cartão PISA'
    
    expect(page).to have_content('Cartão PISA')
    expect(page).to_not have_content('Boleto')
    expect(page).to have_content('5,5')
    expect(page).to have_content('R$ 250,00')
    expect(page).to have_content('Inativo')
  end

  it 'and no payment methods in the system' do
    admin_login
    visit admin_payment_methods_path

    expect(page).to have_content('Nenhum método cadastrado')
  end
end
