class Portfolio < ApplicationRecord
  has_many :requested_stock_transactions, dependent: :destroy
  belongs_to :user_base, foreign_key: :user_id

  def stock_transactions
    StockTransaction.where("source_portfolio_id = ? OR target_portfolio_id = ?", self.id, self.id)
  end

  def available_stock_count(symbol)
    bought = stock_transactions.where(symbol:, target_portfolio_id: id).sum(:quantity)
    sold = stock_transactions.where(symbol:, source_portfolio_id: id).sum(:quantity)
    bought - sold
  end

  def request_to_sell(symbol:, quantity:, price:)
    pending_quantity = requested_stock_transactions.sell.pending.in_transaction_window.sum(:quantity)
    if (pending_quantity + quantity) > available_stock_count(symbol)
      raise WalletError.new("stock quantity not enough")
    end
    requested_stock_transactions.create!(symbol:, transaction_type: "sell", quantity:, price:)
  end

  def request_to_buy(symbol:, quantity:, price:)
    pending_amount = requested_stock_transactions.buy.pending.in_transaction_window.inject(0) { |r, e| r += e.quantity * e.price }
    if pending_amount + (quantity * price) > user_base.wallet.balance
      raise WalletError.new("Balance not enough")
    end
    requested_stock_transactions.create!(symbol:, transaction_type: "buy", quantity:, price:)
  end
end
