class Receipt < ApplicationRecord
  belongs_to :order

  before_validation :generate_token

  private

  def generate_token
    return if token
    
    new_token = SecureRandom.base58(20)
    duplicity = Receipt.where(token: new_token)
    generate_token if duplicity.any?
    self.token = new_token
  end
end
