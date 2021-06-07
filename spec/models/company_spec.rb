require 'rails_helper'

describe Company do
  it { should validate_presence_of(:email_domain).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:cnpj).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:name).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:billing_adress).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:billing_email).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:token).with_message('não pode ficar em branco') }

  it { should validate_uniqueness_of(:email_domain).with_message('já está em uso') }
  it { should validate_uniqueness_of(:cnpj).with_message('já está em uso') }
  it { should validate_uniqueness_of(:name).with_message('já está em uso') }
  it { should validate_uniqueness_of(:billing_adress).with_message('já está em uso') }
  it { should validate_uniqueness_of(:billing_email).with_message('já está em uso') }
  it { should validate_uniqueness_of(:token).with_message('já está em uso') }

  it { should validate_length_of(:cnpj).is_equal_to(14).with_message('não possui o tamanho esperado (14 caracteres)') }
end
