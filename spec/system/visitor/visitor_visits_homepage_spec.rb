require 'rails_helper'

describe 'visitor visits homepage' do
  it 'sucessfully' do
    visit root_path

    expect(page).to have_content('Paynow')
    expect(page).to have_content('Sua plataforma de pagamentos para e-commerce')
    expect(page).to have_link('Home', href: root_path)
    expect(page).to have_link('Login')
    expect(page).to have_link('Cadastre-se')
  end
end