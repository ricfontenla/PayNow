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
    return if token

    new_token = SecureRandom.base58(20)
    duplicity = Product.where(token: new_token)
    generate_token if duplicity.any?
    self.token = new_token
  end

  def create_history
    product_histories.create(name: name, price: price,
                             pix_discount: pix_discount,
                             card_discount: card_discount,
                             boleto_discount: boleto_discount)
  end
end
