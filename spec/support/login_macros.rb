module LoginMacros
  def admin_login
    admin = Admin.create!(email: 'ademir@paynow.com.br', 
                          password: '123456')

    login_as admin, scope: :admin
  end
end