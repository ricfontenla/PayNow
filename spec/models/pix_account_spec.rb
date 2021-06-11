require 'rails_helper'

describe PixAccount do
  it { should validate_presence_of(:pix_key)
        .with_message('não pode ficar em branco') }
  it { should validate_presence_of(:bank_code)
        .with_message('não pode ficar em branco') }

  it { should validate_length_of(:pix_key).is_equal_to(20)
      .with_message('não possui o tamanho esperado (20 caracteres)') }

  it { should allow_value("1234567890qwertyuiop").for(:pix_key) }
  it { should_not allow_value("1234567890qwertyuio#").for(:pix_key)
      .with_message('não é válido') }

  context 'registers boleto_account' do
    it 'fields should be unique' do
      pix = PaymentMethod.create!(name: 'PIX Banco Roxinho', 
                                billing_fee: 1, 
                                max_fee: 250,
                                status: true,
                                category: 3)
      company = Company.create!(email_domain: 'codeplay.com.br', 
                                cnpj: '00000000000000', 
                                name: 'Codeplay Cursos SA', 
                                billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                                billing_email: 'financas@codeplay.com.br',
                                token: SecureRandom.base58(20))
      PixAccount.create!(pix_key: '12345abcde67890FGHIJ',
                         bank_code: '001',
                         company: company,
                         payment_method: pix)
      user = User.create!(email: 'jane_doe@codeplay.com.br', 
                          password: '123456', 
                          role: 0,
                          company: company)
                          
      should validate_uniqueness_of(:pix_key).with_message('já está em uso')
    end
  end
end
