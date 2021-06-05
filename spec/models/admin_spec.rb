require 'rails_helper'

describe Admin do
  it { should allow_value("ademir@paynow.com.br").for(:email) }
  it { should_not allow_value("ademir@google.com").for(:email).with_message('não é válido') }
end
