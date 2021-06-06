class RenameActiveColumnOfPaymentMethod < ActiveRecord::Migration[6.1]
  def change
    rename_column :payment_methods, :active, :status
  end
end
