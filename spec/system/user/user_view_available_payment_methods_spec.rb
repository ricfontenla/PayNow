require 'rails_helper'

describe 'user views only available payment methods' do
  it 'successfully' do
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
                                max_fee: 150,
                                status: true,
                                category: 3)
    card = PaymentMethod.create!(name: 'MESTRECARD', 
                                 billing_fee: 3, 
                                 max_fee: 1000,
                                 status: true,
                                 category: 2)
    pix = PaymentMethod.create!(name: 'PIX Banco SantoAndré', 
                                billing_fee: 1.5, 
                                max_fee: 200,
                                status: false,
                                category: 3)

    user_customer_admin_login
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Novo Método de Pagamento'

    expect(current_path).to eq(user_company_payment_methods_path(Company.last.token))
    expect(page).to have_content('Boleto do Banco Laranja')
    expect(page).to have_css("img[src*='boleto.png']")
    expect(page).to have_content('PIX Banco Roxinho')
    expect(page).to have_css("img[src*='pix.png']")
    expect(page).to have_content('MESTRECARD')
    expect(page).to have_css("img[src*='card.png']")
    expect(page).to_not have_content('PIX Banco SantoAndré')
    expect(page).to_not have_content('PISA')
  end

  it 'and view details' do
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                   billing_fee: 2.5, 
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)

    user_customer_admin_login
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Novo Método de Pagamento'
    click_on 'Boleto do Banco Laranja'
    
    expect(page).to have_content('Boleto do Banco Laranja')
    expect(page).to have_content('2,5')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('Boleto')
  end

  it 'and no available payment methods' do
    user_customer_admin_login
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Novo Método de Pagamento'

    expect(page).to have_content('Nenhum método de pagamento ativo')
  end
end