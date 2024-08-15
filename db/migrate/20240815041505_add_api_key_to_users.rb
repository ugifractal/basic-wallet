class AddApiKeyToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :api_key, :string
  end
end
