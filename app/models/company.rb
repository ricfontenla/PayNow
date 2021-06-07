class Company < ApplicationRecord
  validates :email_domain, :cnpj, :name, :billing_adress, 
            :billing_email, :token, presence: true, uniqueness: true
  validates :cnpj, length: { is: 14 }
end
