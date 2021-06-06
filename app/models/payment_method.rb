class PaymentMethod < ApplicationRecord
  has_one_attached :category_icon
  validates :name, :billing_fee, :max_fee, :category, presence: true
  validates :name, uniqueness: true
  
  enum category: { boleto: 1, card: 2, pix: 3 }
end
