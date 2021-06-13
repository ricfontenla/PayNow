class CompanyFinalCustomer < ApplicationRecord
  belongs_to :company
  belongs_to :final_customer

  validates :final_customer_id, uniqueness: { scope: :company_id }
end
