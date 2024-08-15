class CreateRequestedStockTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :requested_stock_transactions do |t|
      t.integer :portfolio_id
      t.string :symbol
      t.integer :price
      t.integer :quantity
      t.string :transaction_type
      t.string :status, default: 'pending'
      t.datetime :completed_at
      t.timestamps
    end
  end
end
