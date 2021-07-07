class PixAccount < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method

  ALPHANUMERIC = /\A[a-zA-Z0-9]+\Z/

  validates :pix_key, :bank_code, presence: true
  validates :pix_key, uniqueness: true
  validates :pix_key, length: { is: 20 }
  validates :pix_key, format: { with: ALPHANUMERIC }
end
