class AddCompanyRefToCardAccount < ActiveRecord::Migration[6.1]
  def change
    add_reference :card_accounts, :company, null: false, foreign_key: true
  end
end
