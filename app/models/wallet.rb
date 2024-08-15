class Wallet < ApplicationRecord
  belongs_to :user_base, foreign_key: :user_id

  def transactions
    Transaction.where("source_wallet_id = ? OR target_wallet_id = ?", id, id).order(created_at: :desc)
  end

  def credits
    transactions.where(target_wallet_id: self.id)
  end

  def debits
    transactions.where(source_wallet_id: self.id)
  end

  def balance
    credits.sum(:amount) - debits.sum(:amount)
  end

  def transfer!(to:, amount:)
    raise WalletError.new("Not enough balance") if amount > balance
    Transaction.create!(target_wallet_id: to.id, source_wallet_id: id, amount:)
  end

  def top_up!(amount)
    Transaction.create!(target_wallet_id: id, amount:)
  end
end
