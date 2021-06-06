class PaymentMethod < ApplicationRecord
  has_one_attached :category_icon
  
  enum category: { boleto: 1, card: 2, pix: 3 }
end
