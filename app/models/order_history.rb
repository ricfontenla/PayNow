class OrderHistory < ApplicationRecord
  belongs_to :order

  enum status: { pendente: 1, aprovado: 2 }
end
