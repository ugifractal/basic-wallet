class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.integer :user_id
      t.integer :team_id
      t.timestamps
    end
  end
end
