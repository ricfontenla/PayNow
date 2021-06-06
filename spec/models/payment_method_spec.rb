require 'rails_helper'

describe PaymentMethod do
  it { should validate_uniqueness_of(:name).with_message('já está em uso') }
end
