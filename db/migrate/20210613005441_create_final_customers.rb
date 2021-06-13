class CreateFinalCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :final_customers do |t|
      t.string :name
      t.string :cpf
      t.string :token

      t.timestamps
    end
  end
end
