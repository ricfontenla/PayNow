require 'rails_helper'

describe Product do
  it { should validate_presence_of(:name)
        .with_message('não pode ficar em branco') }
  it { should validate_presence_of(:price)
        .with_message('não pode ficar em branco') }
  it { should validate_presence_of(:pix_discount)
        .with_message('não pode ficar em branco') }
  it { should validate_presence_of(:card_discount)
        .with_message('não pode ficar em branco') }
  it { should validate_presence_of(:boleto_discount)
        .with_message('não pode ficar em branco') }

  it { should validate_numericality_of(:price)
        .is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:pix_discount)
        .is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:card_discount)
        .is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:boleto_discount)
        .is_greater_than_or_equal_to(0) }

  context 'registers product' do
    it 'should be unique' do
      company = Company.create!(email_domain: 'codeplay.com.br', 
                              cnpj: '00000000000000', 
                              name: 'Codeplay Cursos SA', 
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
      Product.create!(name: 'Curso Ruby Básico',
                      price:'100',
                      pix_discount: 10,
                      card_discount: 0,
                      boleto_discount: 5, 
                      company: company)

      should validate_uniqueness_of(:name).with_message('já está em uso')
    end
  end
end
