class CreatePixAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :pix_accounts do |t|
      t.string :pix_key
      t.string :bank_code

      t.timestamps
    end
  end
end
