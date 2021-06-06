class AddColumnToPaymentMethod < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_methods, :category, :integer
  end
end
