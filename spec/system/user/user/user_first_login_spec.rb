require 'rails_helper'

describe "user logins for the first time" do
  context 'and registers a company' do
    it 'sucessfully' do
      user_first_login
      visit root_path
      click_on 'Cadastre sua Empresa'
      fill_in 'Nome', with: 'Codeplay Cursos SA'
      fill_in 'CNPJ', with: '00000000000000'
      fill_in 'Endereço de cobrança', with: 'Rua banana, numero 00 - Bairro Laranja, 00000-000'
      fill_in 'Email de cobrança', with: 'financas@codeplay.com.br'
      click_on 'Cadastrar'

      expect(current_path).to eq(user_company_path(Company.last.token))
      expect(page).to have_content('codeplay.com.br')
      expect(page).to have_content('00000000000000')
      expect(page).to have_content('Codeplay Cursos SA')
      expect(page).to have_content('Rua banana, numero 00 - Bairro Laranja, 00000-000')
      expect(page).to have_content('financas@codeplay.com.br')
      expect(page).to have_content(Company.last.token)
      expect(User.last.role).to eq('customer_admin')
      expect(User.last.company).to eq(Company.last)
    end

    it 'and fields cannot be blank' do
      user_first_login
      visit root_path
      click_on 'Cadastre sua Empresa'
      click_on 'Cadastrar'
  
      expect(page).to have_content('não pode ficar em branco', count: 4)
      expect(page).to have_content('não possui o tamanho esperado')
    end

    it 'and fields must be unique' do
      Company.create!(email_domain: 'teste.com.br', 
                      cnpj: '00000000000000', 
                      name: 'Codeplay Cursos SA', 
                      billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                      billing_email: 'financas@codeplay.com.br',
                      token: SecureRandom.base58(20))

      user_first_login
      visit root_path
      click_on 'Cadastre sua Empresa'
      fill_in 'Nome', with: 'Codeplay Cursos SA'
      fill_in 'CNPJ', with: '00000000000000'
      fill_in 'Endereço de cobrança', with: 'Rua banana, numero 00 - Bairro Laranja, 00000-000'
      fill_in 'Email de cobrança', with: 'financas@codeplay.com.br'
      click_on 'Cadastrar'

      expect(page).to have_content('já está em uso', count: 4)
    end
  end

  context 'and his company is already registered' do
    it 'and he continues as a customer and is automatically associated with the company' do
      company = Company.create!(email_domain: 'codeplay.com.br', 
                                cnpj: '00000000000000', 
                                name: 'Codeplay Cursos SA', 
                                billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                                billing_email: 'financas@codeplay.com.br',
                                token: SecureRandom.base58(20))

      user_first_login
      visit root_path

      expect(page).to have_content('Minha Empresa')
      expect(User.last.company).to eq(company)
    end
  end
end
