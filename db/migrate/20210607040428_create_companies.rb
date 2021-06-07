class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :email_domain
      t.string :cnpj
      t.string :name
      t.string :billing_adress
      t.string :billing_email
      t.string :token

      t.timestamps
    end
  end
end
