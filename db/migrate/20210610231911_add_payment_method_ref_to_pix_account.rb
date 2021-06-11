class AddPaymentMethodRefToPixAccount < ActiveRecord::Migration[6.1]
  def change
    add_reference :pix_accounts, :payment_method, null: false, foreign_key: true
  end
end
