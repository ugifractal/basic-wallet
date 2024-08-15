class RemoveTransactionTypeFromTransactions < ActiveRecord::Migration[7.2]
  def change
    remove_column :transactions, :transaction_type, :string
  end
end
