class CreateCompanyFinalCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :company_final_customers do |t|
      t.belongs_to :company, null: false, foreign_key: true
      t.belongs_to :final_customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
