class AddOrderRefToOrderHistory < ActiveRecord::Migration[6.1]
  def change
    add_reference :order_histories, :order, null: false, foreign_key: true
  end
end
