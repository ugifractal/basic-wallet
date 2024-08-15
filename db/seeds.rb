# Cleanup
StockTransaction.destroy_all
RequestedStockTransaction.destroy_all
Transaction.destroy_all
UserBase.destroy_all
Wallet.destroy_all

# Create User
user = User.new(email: 'ugidmtest@gmail.com')
user.password = 'qwerty1'
user.password_confirmation = 'qwerty1'
user.save!

# Create Team
team = Team.new(email: 'team@gmail.com')
team.password = 'qwerty1'
team.password_confirmation = 'qwerty1'
team.save!

# Give initial balance to user $1000, for amount we use integer multiple by 100
Transaction.create!(target_wallet_id: user.wallet.id, amount: 100000)

# Give initial stocks to team 1000 items with $1 price for each
# GOTO is sample stock from indonesia for Gojek/tokopedia
StockTransaction.create!(target_portfolio_id: team.portfolio.id, quantity: 1000, price: 100, symbol: "GOTO")



