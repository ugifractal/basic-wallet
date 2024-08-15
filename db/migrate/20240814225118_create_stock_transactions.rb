class CreateStockTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_transactions do |t|
      t.integer :source_portfolio_id
      t.integer :target_portfolio_id
      t.string :symbol
      t.integer :quantity
      t.integer :price
      t.timestamps
    end
  end
end
