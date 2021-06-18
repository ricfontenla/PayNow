class CreateCompanyHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :company_histories do |t|
      t.string :name
      t.string :cnpj
      t.string :billing_adress
      t.string :billing_email
      t.string :token
      t.belongs_to :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
