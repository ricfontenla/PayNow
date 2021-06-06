class PaymentMethod < ApplicationRecord
  enum category: { boleto: 1, card: 2, pix: 3 }
end
