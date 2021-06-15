class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.string :token
      t.belongs_to :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
