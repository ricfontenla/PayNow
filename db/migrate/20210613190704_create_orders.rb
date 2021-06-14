class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :token
      t.integer :status, default: 1
      t.decimal :original_price
      t.decimal :final_price
      t.integer :choosen_payment
      t.string :adress
      t.string :card_number
      t.string :printed_name
      t.string :verification_code
      t.belongs_to :company, null: false, foreign_key: true
      t.belongs_to :final_customer, null: false, foreign_key: true
      t.belongs_to :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
