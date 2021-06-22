require 'rails_helper'

describe "User customer admin changes users status" do
  it 'successfully' do
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    user = User.create!(email: 'john_doe@codeplay.com.br', 
                        password: '123456', 
                        role: 10,
                        company: company)
    User.create!(email: 'john_doe2@codeplay.com.br', 
                 password: '123456',
                 role: 0,
                 company: company)

    login_as user, scope: :user
    visit root_path
    click_on 'Minha Empresa'
    click_on 'Alterar status'

    expect(User.last.status).to eq(false)
  end

  it 'and user cannot login if deactivated' do
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    User.create!(email: 'john_doe@codeplay.com.br', 
                        password: '123456', 
                        role: 10,
                        company: company)
    User.create!(email: 'john_doe2@codeplay.com.br', 
                 password: '123456',
                 role: 0,
                 company: company,
                 status: false)
    
    visit new_user_session_path
    fill_in "Email",	with: "john_doe2@codeplay.com.br" 
    fill_in "Senha",	with: "123456"
    click_on 'Entrar'
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('Sua conta não está ativa.')
  end
end
