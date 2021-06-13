require 'rails_helper'

describe CardAccount do
  it { should validate_presence_of(:credit_code)
      .with_message('não pode ficar em branco') }

  it { should validate_length_of(:credit_code).is_equal_to(20)
      .with_message('não possui o tamanho esperado (20 caracteres)') }

  it { should allow_value("1234567890qwertyuiop").for(:credit_code) }

  it { should_not allow_value("1234567890qwertyuio#").for(:credit_code)
      .with_message('não é válido') }
  
  context 'registers boleto_account' do
    it 'fields should be unique' do
      company = Company.create!(email_domain: 'codeplay.com.br', 
                          cnpj: '00000000000000', 
                          name: 'Codeplay Cursos SA', 
                          billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                          billing_email: 'financas@codeplay.com.br')
      user =  User.create!(email: 'john_doe@codeplay.com.br', 
                           password: '123456',
                           role: 10,
                           company: company)
      card = PaymentMethod.create!(name: 'PISA', 
                                 billing_fee: 5, 
                                 max_fee: 250,
                                 status: true,
                                 category: 2)
      CardAccount.create!(credit_code: '9876543210ABCDEfghij',
                          company: company,
                          payment_method: card)
    
      should validate_uniqueness_of(:credit_code)
              .with_message('já está em uso')
    end
  end
end
