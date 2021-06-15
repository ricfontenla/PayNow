class CreateOrderHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :order_histories do |t|
      t.integer :status, default: 1
      t.string :response_code, default: '01 - Pendente de cobrança'

      t.timestamps
    end
  end
end
