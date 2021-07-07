class CardAccount < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method

  ALPHANUMERIC = /\A[a-zA-Z0-9]+\Z/

  validates :credit_code, presence: true
  validates :credit_code, length: { is: 20 }
  validates :credit_code, format: { with: ALPHANUMERIC }
  validates :credit_code, uniqueness: true
end
