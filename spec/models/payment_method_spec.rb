require 'rails_helper'

describe PaymentMethod do
  it { should validate_uniqueness_of(:name).with_message('já está em uso') }
  it { should validate_numericality_of(:billing_fee).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:max_fee).is_greater_than_or_equal_to(0) }
end
