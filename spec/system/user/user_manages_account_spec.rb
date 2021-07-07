require 'rails_helper'

describe 'User manages account' do
  context 'and registers' do
    it 'sucessfully' do
      visit root_path
      click_on 'Cadastre-se'
      fill_in 'Email', with: 'john_doe@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      click_on 'Cadastrar'

      expect(current_path).to eq(root_path)
      expect(page).to have_content('john_doe@codeplay.com.br')
      expect(page).to have_link('Sair', href: destroy_user_session_path)
      expect(page).to have_content('Login efetuado com sucesso.')
    end

    it 'and fields cannot be blank' do
      visit new_user_registration_path
      click_on 'Cadastrar'

      expect(page).to have_content('não pode ficar em branco', count: 2)
    end

    it 'and cannot use unauthorized emails' do
      visit root_path
      click_on 'Cadastre-se'
      fill_in 'Email', with: 'john_doe@google.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      click_on 'Cadastrar'

      expect(page).to have_content('não é válido')
    end
  end

  context 'and tries to login' do
    it 'sucessfully' do
      User.create!(email: 'john_doe@codeplay.com.br',
                   password: '123456',
                   role: 0)

      visit root_path
      click_on 'Login'
      fill_in 'Email', with: 'john_doe@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'

      expect(current_path).to eq(root_path)
      expect(page).to have_link('Sair', href: destroy_user_session_path)
    end

    it 'and mistakes password or email' do
      User.create!(email: 'john_doe@codeplay.com.br',
                   password: '123456',
                   role: 0)

      visit new_user_session_path
      fill_in 'Email', with: 'johndoe@codeplay.com.br'
      fill_in 'Senha', with: '654321'
      click_on 'Entrar'

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Email ou senha inválida.')
      expect(page).to have_content('Área do Cliente')
    end
  end

  context 'and forgot his password' do
    it 'and try to recover' do
      User.create!(email: 'john_doe@codeplay.com.br',
                   password: '123456',
                   role: 0)

      visit new_user_session_path
      click_on 'Esqueceu sua senha?'
      fill_in 'Email', with: 'john_doe@codeplay.com.br'
      click_on 'Enviar instruções para trocar a senha'

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Dentro de minutos, você receberá um e-mail '\
                                   'com instruções para a troca da sua senha')
    end

    it 'and reset password' do
      user = User.create!(email: 'john_doe@codeplay.com.br',
                          password: '123456',
                          role: 0)
      token = user.send_reset_password_instructions

      visit edit_user_password_path(reset_password_token: token)
      fill_in 'Senha', with: '654321'
      fill_in 'Confirmar senha', with: '654321'
      click_on 'Alterar minha senha'

      expect(page).to have_content('Sua senha foi alterada com sucesso. '\
                                   'Você está logado.')
      expect(current_path).to eq(root_path)
    end
  end
end
