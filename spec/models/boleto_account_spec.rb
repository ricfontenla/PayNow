require 'rails_helper'

describe BoletoAccount do    
  it { should validate_presence_of(:bank_code).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:agency_number).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:bank_account).with_message('não pode ficar em branco') }

  it { should validate_length_of(:agency_number).is_equal_to(4).with_message('não possui o tamanho esperado (4 caracteres)') }
  it { should validate_length_of(:bank_account).is_equal_to(9).with_message('não possui o tamanho esperado (9 caracteres)') }

  context 'registers boleto_account' do
    it 'fields should be unique' do
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

      boleto = PaymentMethod.create!(name: 'Boleto do Banco Laranja', 
                                     billing_fee: 2.5, 
                                     max_fee: 100.0,
                                     status: true,
                                     category: :boleto)
      BoletoAccount.create!(bank_code:  479,
                            agency_number:  1234,
                            bank_account: 123456789,
                            company: company,
                            payment_method: boleto)

      should validate_uniqueness_of(:bank_account).scoped_to(:bank_code).case_insensitive.with_message('já está em uso')
    end
  end
  
end
