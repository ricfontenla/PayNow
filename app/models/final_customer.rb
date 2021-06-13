class FinalCustomer < ApplicationRecord
  has_many :company_final_customers
  has_many :companies, through: :company_final_customers

  before_validation :generate_token

  ONLY_NUMBERS =  /\A[0-9]+\Z/

  validates :cpf, format: { with: ONLY_NUMBERS }
  validates :name, :cpf, :token, presence: true
  validates :cpf, length: { is: 11 }
  validates :cpf, :token, uniqueness: true
  
  private

  def generate_token
    unless self.token
      new_token = SecureRandom.base58(20)
      duplicity = FinalCustomer.where(token: new_token)
      generate_token if duplicity.any?
      self.token = new_token    
    end
  end
end
