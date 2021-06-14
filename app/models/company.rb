class Company < ApplicationRecord
  validates :email_domain, :cnpj, :name, :billing_adress, 
            :billing_email, :token, presence: true, uniqueness: true
  validates :cnpj, length: { is: 14 }

  has_many :users
  has_many :boleto_accounts
  has_many :card_accounts
  has_many :pix_accounts
  has_many :products
  has_many :company_final_customers
  has_many :final_customers, through: :company_final_customers
  has_many :orders

  before_validation :generate_token

  private

  def generate_token
    unless self.token
      new_token = SecureRandom.base58(20)
      duplicity = Company.where(token: new_token)
      generate_token if duplicity.any?
      self.token = new_token    
    end
  end
end
