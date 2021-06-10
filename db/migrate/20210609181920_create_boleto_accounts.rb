class CreateBoletoAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :boleto_accounts do |t|
      t.string :bank_code
      t.string :agency_number
      t.string :bank_account

      t.timestamps
    end
  end
end
