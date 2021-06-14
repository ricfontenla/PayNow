class Product < ApplicationRecord
  belongs_to :company
  has_many :orders

  before_validation :generate_token

  validates :name, :price, :pix_discount, :card_discount, :boleto_discount, presence: true
  validates :name, :token, uniqueness: true
  validates :price, :pix_discount, :card_discount, :boleto_discount, 
            numericality: { greater_than_or_equal_to: 0 }


  private
  def generate_token
    unless self.token
      new_token = SecureRandom.base58(20)
      duplicity = Product.where(token: new_token)
      generate_token if duplicity.any?
      self.token = new_token    
    end
  end
end
