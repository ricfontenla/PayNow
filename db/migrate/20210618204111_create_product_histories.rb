class CreateProductHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :product_histories do |t|
      t.string :name
      t.decimal :price
      t.decimal :pix_discount
      t.decimal :card_discount
      t.decimal :boleto_discount
      t.belongs_to :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
