class Product < ApplicationRecord
  belongs_to :company
  has_many :orders
  has_many :product_histories, dependent: :destroy

  before_validation :generate_token

  validates :name, :price, :pix_discount, :card_discount, :boleto_discount, presence: true
  validates :name, :token, uniqueness: true
  validates :price, :pix_discount, :card_discount, :boleto_discount, 
            numericality: { greater_than_or_equal_to: 0 }

  after_create :create_history
  after_update :create_history

  private
  def generate_token
    unless self.token
      new_token = SecureRandom.base58(20)
      duplicity = Product.where(token: new_token)
      generate_token if duplicity.any?
      self.token = new_token    
    end
  end

  def create_history
    self.product_histories.create(name: self.name, price: self.price, 
                                  pix_discount: self.pix_discount, 
                                  card_discount: self.card_discount, 
                                  boleto_discount: self.boleto_discount)
  end
end
