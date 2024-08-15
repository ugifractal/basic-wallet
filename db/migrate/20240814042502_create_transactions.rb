class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.integer :source_wallet_id
      t.integer :target_wallet_id
      t.integer :amount, null: false
      t.string :transaction_type
      t.timestamps
    end
  end
end
