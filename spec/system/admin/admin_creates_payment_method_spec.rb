require 'rails_helper'

describe 'Admin creates payment method' do
  it 'sucessfully' do
    admin_login
    visit root_path
    click_on 'Métodos de Pagamento'
    click_on 'Cadastrar Método de Pagamento'
    fill_in 'Nome', with: 'Boleto do Banco Laranja'
    fill_in 'Taxa por cobrança (%)', with: 2.5
    fill_in 'Taxa máxima', with: 100
    select 'Ativo', from: 'Status'
    select 'Boleto', from: 'Categoria'
    click_on 'Enviar'

    expect(current_path).to eq(admin_payment_method_path(PaymentMethod.last))
    expect(page).to have_content('Boleto do Banco Laranja')
    expect(page).to have_content('2,5')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('Ativo')
    expect(page).to have_content('Boleto')
    expect(page).to have_css("img[src*='boleto.png']")
    expect(page).to have_link('Voltar', href: admin_payment_methods_path)
  end

  it 'and attributes cannot be blank' do
    admin_login
    visit new_admin_payment_method_path
    click_on 'Enviar'

    expect(page).to have_content('Novo Método de Pagamento')
    expect(page).to have_content('não pode ficar em branco', count: 4)
  end

  it 'and name must be unique' do
    PaymentMethod.create!(name: 'Boleto do Banco Laranja',
                          billing_fee: 2.5,
                          max_fee: 100.0,
                          status: true,
                          category: :boleto)

    admin_login
    visit new_admin_payment_method_path
    fill_in 'Nome', with: 'Boleto do Banco Laranja'
    fill_in 'Taxa por cobrança (%)', with: 3
    fill_in 'Taxa máxima', with: 200
    select 'Ativo', from: 'Status'
    select 'Boleto', from: 'Categoria'
    click_on 'Enviar'

    expect(page).to have_content('Novo Método de Pagamento')
    expect(page).to have_content('já está em uso')
  end
end
