require 'rails_helper'

describe 'Admin manages account' do
  context 'and tries to login' do
    it 'and succeds' do
      admin = Admin.create!(email: 'ademir@paynow.com.br', password: '123456')

      visit new_admin_session_path

      fill_in 'Email', with: 'ademir@paynow.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'

      expect(current_path).to eq(root_path)
    end

    it 'and digits wrong password or email' do
      admin = Admin.create!(email: 'ademir@paynow.com.br', password: '123456')

      visit new_admin_session_path
    
      fill_in 'Email', with: 'usermir@dontpaynow.com.br'
      fill_in 'Senha', with: '654321'
      click_on 'Entrar'

      expect(current_path).to eq(new_admin_session_path)
      expect(page).to have_content('Email ou senha inválida.')
      expect(page).to have_content('Área do Administrador')
    end
  end

  context ''
end