require 'rails_helper'

describe Order do
  it { should validate_presence_of(:status).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:original_price).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:final_price).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:choosen_payment).with_message('não pode ficar em branco') }

  context 'if boleto' do
    before { allow(subject).to receive(:boleto?).and_return(true) }
    it{ should validate_presence_of(:adress) }
  end

  context 'if card' do
    before { allow(subject).to receive(:card?).and_return(true) }

    it{ should validate_presence_of(:card_number) }
    it{ should validate_presence_of(:printed_name) }
    it{ should validate_presence_of(:verification_code) }

    it { should validate_length_of(:card_number).is_equal_to(16).with_message('não possui o tamanho esperado (16 caracteres)') }
    it { should validate_length_of(:verification_code).is_equal_to(3).with_message('não possui o tamanho esperado (3 caracteres)') }

    it { should allow_value("9876543210123456").for(:card_number) }
    it { should_not allow_value("987654321012345p").for(:card_number).with_message('não é válido') }
    it { should allow_value("000").for(:verification_code) }
    it { should_not allow_value("#00").for(:verification_code).with_message('não é válido') }
  end
end
