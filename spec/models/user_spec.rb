require 'rails_helper'

describe User do
  it { should allow_value("john_doe@codeplay.com.br").for(:email) }
  it { should_not allow_value("john_doe@google.com").for(:email).with_message('não é válido') }
  it { should_not allow_value("john_doe@yahoo.com").for(:email).with_message('não é válido') }
  it { should_not allow_value("john_doe@hotmail.com").for(:email).with_message('não é válido') }
  it { should_not allow_value("john_doe@paynow.com").for(:email).with_message('não é válido') }
end
