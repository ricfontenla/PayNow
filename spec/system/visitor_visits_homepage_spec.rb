require 'rails_helper'

describe 'visitor visits homepage' do
  it 'sucessfully' do
    visit root_path

    expect(page).to have_content('Paynow')
    expect(page).to have_content('Sua plataforma de pagamentos para e-commerce')
  end
end