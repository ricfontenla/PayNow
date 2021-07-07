require 'rails_helper'

describe FinalCustomer do
  it { should validate_presence_of(:name).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:cpf).with_message('não pode ficar em branco') }

  it { should validate_uniqueness_of(:cpf).with_message('já está em uso') }
  it { should validate_uniqueness_of(:token).with_message('já está em uso') }

  it {
    should validate_length_of(:cpf).is_equal_to(11)
                                   .with_message('não possui o tamanho esperado (11 caracteres)')
  }

  it { should allow_value('98765432101').for(:cpf) }
  it { should_not allow_value('9876543210f').for(:cpf).with_message('não é válido') }
end
