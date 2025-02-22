class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.decimal :balance
      t.boolean :min_balance_enforced
      t.decimal :min_balance_amount

      t.timestamps
    end
  end
end
