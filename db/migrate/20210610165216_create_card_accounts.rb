class CreateCardAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :card_accounts do |t|
      t.string :credit_code

      t.timestamps
    end
  end
end
