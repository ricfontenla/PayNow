module LoginMacros
  def admin_login
    admin = Admin.create!(email: 'ademir@paynow.com.br', 
                          password: '123456')

    login_as admin, scope: :admin
  end

  def customer_admin_login
    customer_admin = User.create!(email: 'john_doe@codeplay.com.br', 
                        password: '123456',
                        role: 10)

    login_as customer_admin, scope: :user
  end
end