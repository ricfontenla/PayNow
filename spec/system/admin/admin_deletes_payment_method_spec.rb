require 'rails_helper'

describe 'Admin deletes payment method' do
  it 'sucessfully' do
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja',
                                   billing_fee: 2.5,
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)

    admin_login
    visit admin_payment_method_path(boleto)

    expect { click_on 'Deletar' }.to change { PaymentMethod.count }.by(-1)
    expect(current_path).to eq(admin_payment_methods_path)
    expect(page).to have_content('apagado com sucesso')
  end

  it 'and boleto accounts are deleted together' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    User.create!(email: 'john_doe@codeplay.com.br',
                 password: '123456',
                 role: 10,
                 company: company)
    boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja',
                                   billing_fee: 2.5,
                                   max_fee: 100.0,
                                   status: true,
                                   category: :boleto)
    BoletoAccount.create!(bank_code: 479,
                          agency_number: 1234,
                          bank_account: 123_456_789,
                          company: company,
                          payment_method: boleto)

    admin_login
    visit admin_payment_method_path(boleto)

    expect { click_on 'Deletar' }.to change { BoletoAccount.count }.by(-1)
  end

  it 'and card accounts are deleted together' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    User.create!(email: 'john_doe@codeplay.com.br',
                 password: '123456',
                 role: 10,
                 company: company)
    card = PaymentMethod.create!(name: 'Boleto do Banco Laranja',
                                 billing_fee: 2.5,
                                 max_fee: 100.0,
                                 status: true,
                                 category: :boleto)
    CardAccount.create!(credit_code: '9876543210ABCDEfghij',
                        company: company,
                        payment_method: card)

    admin_login
    visit admin_payment_method_path(card)

    expect { click_on 'Deletar' }.to change { CardAccount.count }.by(-1)
  end

  it 'and pix accounts are deleted together' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    User.create!(email: 'john_doe@codeplay.com.br',
                 password: '123456',
                 role: 10,
                 company: company)
    pix = PaymentMethod.create!(name: 'Boleto do Banco Laranja',
                                billing_fee: 2.5,
                                max_fee: 100.0,
                                status: true,
                                category: :boleto)
    PixAccount.create!(pix_key: '12345abcde67890FGHIJ',
                       bank_code: '001',
                       company: company,
                       payment_method: pix)

    admin_login
    visit admin_payment_method_path(pix)

    expect { click_on 'Deletar' }.to change { PixAccount.count }.by(-1)
  end
end
