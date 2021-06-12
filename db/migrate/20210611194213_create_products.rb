class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.decimal :pix_discount
      t.decimal :card_discount
      t.decimal :boleto_discount
      t.string :token, null: false

      t.timestamps
    end
  end
end
