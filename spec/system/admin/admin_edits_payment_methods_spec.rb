require 'rails_helper'

describe 'Admin edits payment method' do
  it 'sucessfully' do
    card = PaymentMethod.create!(name: 'PISA', 
                                 billing_fee: 5, 
                                 max_fee: 250,
                                 status: false,
                                 category: 2)
    card.category_icon
          .attach(io: File.open(Rails.root.join('app/assets/images/icons/card.png')), 
                  filename: 'card.png')

    admin_login
    visit root_path
    click_on 'Métodos de Pagamento'
    click_on 'PISA'
    click_on 'Atualizar'
    fill_in 'Taxa por cobrança (%)', with: 2
    fill_in 'Taxa máxima', with: 300
    select 'Inativo', from: 'Status'
    click_on 'Atualizar'

    expect(current_path).to eq(admin_payment_method_path(card))
    expect(page).to have_content('PISA')
    expect(page).to have_content('2,0')
    expect(page).to have_content('R$ 300,00')
    expect(page).to have_content('Inativo')
    expect(page).to have_content('atualizado com sucesso')
  end

  it 'and attributes cannot be blank' do 
    card = PaymentMethod.create!(name: 'PISA', 
                                 billing_fee: 5, 
                                 max_fee: 250,
                                 status: false,
                                 category: 2)
    card.category_icon
          .attach(io: File.open(Rails.root.join('app/assets/images/icons/card.png')), 
                  filename: 'card.png')

    admin_login
    visit edit_admin_payment_method_path(card)
    fill_in 'Taxa por cobrança (%)', with: ''
    fill_in 'Taxa máxima', with: ''
    click_on 'Atualizar'

    expect(page).to have_content('Atualizar Método de Pagamento')
    expect(page).to have_content('não pode ficar em branco', count: 2)
    expect(page).to have_link('Cancelar', href: admin_payment_method_path(card))
  end
end