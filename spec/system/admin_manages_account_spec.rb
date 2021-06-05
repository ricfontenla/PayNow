require 'rails_helper'

describe 'Admin manages account' do
  context 'and tries to login' do
    it 'sucessfully' do
      admin = Admin.create!(email: 'ademir@paynow.com.br', 
                            password: '123456')

      visit new_admin_session_path

      fill_in 'Email', with: 'ademir@paynow.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'

      expect(current_path).to eq(root_path)
      expect(page).to have_link('Sair', href: destroy_admin_session_path)
    end

    it 'and mistakes password or email' do
      admin = Admin.create!(email: 'ademir@paynow.com.br', 
                            password: '123456')

      visit new_admin_session_path
    
      fill_in 'Email', with: 'usermir@dontpaynow.com.br'
      fill_in 'Senha', with: '654321'
      click_on 'Entrar'

      expect(current_path).to eq(new_admin_session_path)
      expect(page).to have_content('Email ou senha inválida.')
      expect(page).to have_content('Área do Administrador')
    end
  end

  context 'and forgot his password' do
    it 'and try to recover' do
      Admin.create!(email: 'ademir@paynow.com.br', 
                    password: '123456')
  
      visit new_admin_session_path
      click_on 'Esqueceu sua senha?'
      fill_in 'Email', with: 'ademir@paynow.com.br'
      click_on 'Enviar instruções para trocar a senha'
  
      expect(current_path).to eq(new_admin_session_path)
      expect(page).to have_content('Dentro de minutos, você receberá um e-mail com instruções para a troca da sua senha')
    end
    
    it 'and reset password' do
      admin = Admin.create!(email: 'ademir@paynow.com.br', 
                            password: '123456')
      token = admin.send_reset_password_instructions

      visit edit_admin_password_path(reset_password_token: token)
      fill_in 'Senha', with: '654321'
      fill_in 'Confirmar senha', with: '654321'
      click_on 'Alterar minha senha'
      expect(page).to have_content('Sua senha foi alterada com sucesso. Você está logado.')
      expect(current_path).to eq (root_path)
    end  
  end

  context 'and tries to logout' do
    it 'sucessfully' do
      admin = Admin.create!(email: 'ademir@paynow.com.br', 
                            password: '123456')

      login_as admin, scope: :admin
      visit root_path
      click_on 'Sair'

      expect(page).to_not have_link('Sair', href: destroy_admin_session_path)
    end
  end
end