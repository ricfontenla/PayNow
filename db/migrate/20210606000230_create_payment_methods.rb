class CreatePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.decimal :billing_fee
      t.decimal :max_fee
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
