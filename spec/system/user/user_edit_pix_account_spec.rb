require 'rails_helper'

describe 'User edits pix account' do
  it 'successfully' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
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
    visit user_company_path(company.token)
    click_on 'Meus Métodos de Pagamento'
    click_on 'Editar'
    select '184 - Banco Itaú BBA S.A.', from: 'Código do banco'
    fill_in 'Chave PIX',	with: '9876543210ABCDEfghij'
    click_on 'Enviar'

    expect(page).to have_content('PIX Banco Roxinho')
    expect(page).to have_content('184')
    expect(page).to have_content('9876543210ABCDEfghij')
    expect(page).to have_content('Dados para PIX atualizados com sucesso')
  end

  it 'and fields cannot be blank' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
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
    visit edit_user_company_payment_method_pix_account_path(company.token, pix, PixAccount.last.id)
    select '', from: 'Código do banco'
    fill_in 'Chave PIX', with: ''
    click_on 'Enviar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
    expect(page).to have_content('não possui o tamanho esperado')
    expect(page).to have_content('não é válido')
  end

  it 'and must be unique' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    pix = PaymentMethod.create!(name: 'PIX Banco Roxinho',
                                billing_fee: 1,
                                max_fee: 250,
                                status: true,
                                category: 3)
    PixAccount.create!(pix_key: '12345abcde67890FGHIJ',
                       bank_code: '001',
                       company: company,
                       payment_method: pix)
    PixAccount.create!(pix_key: '9876543210ABCDEfghij',
                       bank_code: '246',
                       company: company,
                       payment_method: pix)
    user = User.create!(email: 'jane_doe@codeplay.com.br',
                        password: '123456',
                        role: 0,
                        company: company)

    login_as user, scope: :user
    visit edit_user_company_payment_method_pix_account_path(Company.last.token, pix.id, PixAccount.last.id)
    select '001 - Banco do Brasil S.A.', from: 'Código do banco'
    fill_in 'Chave PIX', with: '12345abcde67890FGHIJ'
    click_on 'Enviar'

    expect(page).to have_content('já está em uso')
  end
end
