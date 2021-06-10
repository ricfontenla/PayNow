class BoletoAccount < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method

  validates :bank_code, :agency_number, :bank_account, presence: true
  validates :bank_account, uniqueness: { case_sensitive: false, scope: :bank_code }
  validates :agency_number, length: { is: 4 }
  validates :bank_account, length: { is: 9 }
end
