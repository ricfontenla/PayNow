require 'rails_helper'

describe 'user deletes pix account' do
  it 'successfully' do
    company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br',
                              token: SecureRandom.base58(20))                          
    user =  User.create!(email: 'john_doe@codeplay.com.br', 
                         password: '123456',
                         role: 10,
                         company: company)
    pix = PaymentMethod.create!(name: 'PIX Banco Roxinho', 
                                billing_fee: 1, 
                                max_fee: 250,
                                status: true,
                                category: 3)
    PixAccount.create!(pix_key: '12345abcde67890FGHIJ',
                       bank_code: '001',
                       company: company,
                       payment_method: pix)

    login_as user, scope: :user
    visit my_payment_methods_user_company_path(company.token)
    click_on 'Deletar'

    expect(page).to have_content('apagados com sucesso')
    expect(page).to have_content('Nenhum dado para recebimento via PIX cadastrado')
    expect(page).to_not have_content('PIX Banco Roxinho')
    expect(page).to_not have_content('12345abcde67890FGHIJ')
    expect(page).to_not have_content('001')
  end
end