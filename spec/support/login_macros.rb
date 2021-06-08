module LoginMacros
  def admin_login
    admin = Admin.create!(email: 'ademir@paynow.com.br', 
                          password: '123456')

    login_as admin, scope: :admin
  end

  def user_first_login
    user = User.create!(email: 'john_doe@codeplay.com.br', 
                        password: '123456',
                        role: 0)
                            
    login_as user, scope: :user
  end

  def user_customer_admin_login
    company = Company.create!(email_domain: 'codeplay.com.br', 
                               cnpj: '00000000000000', 
                               name: 'Codeplay Cursos SA', 
                               billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                               billing_email: 'financas@codeplay.com.br',
                               token: SecureRandom.base58(20))
    user = User.create!(email: 'john_doe@codeplay.com.br', 
                        password: '123456', 
                        role: 10,
                        company: company)
                      
    login_as user, scope: :user
  end

  def user_customer_login
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br',
                              token: SecureRandom.base58(20))
    user = User.create!(email: 'jane_doe@codeplay.com.br', 
                        password: '123456', 
                        role: 0,
                        company: company)

    login_as user, scope: :user
  end
end