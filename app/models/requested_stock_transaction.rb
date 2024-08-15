class RequestedStockTransaction < ApplicationRecord
  MARKET_OPEN = 9.hours
  MARKET_CLOSE = 16.hours

  belongs_to :portfolio

  validates :symbol, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: %w(sell buy) }
  validate :market_time

  scope :sell, -> { where(transaction_type: 'sell') }
  scope :buy, -> { where(transaction_type: 'buy') }
  scope :pending, -> { where(status: "pending") }
  scope :in_transaction_window, -> { where(created_at: ((Time.zone.now.beginning_of_day + MARKET_OPEN)..(Time.zone.now.beginning_of_day + MARKET_CLOSE))) }
  after_commit :find_matching_to_buy, if: proc { |t| t.transaction_type == 'buy' }, on: :create
  after_commit :find_matching_to_sell, if: proc { |t| t.transaction_type == 'sell' }, on: :create

  private

  def find_matching_to_buy
    candidates = []
    total_quantity = 0
    fulfilled = false

    RequestedStockTransaction
      .in_transaction_window
      .pending
      .sell
      .where(price:)
      .where("id <> ?", id)
      .order(created_at: :asc).find_each do |request|
        total_quantity += request.quantity
        candidates << { sell: request, quantity: request.quantity }
        if total_quantity == quantity
          fulfilled = true
          break
        elsif total_quantity >= quantity
          candidates.last[:quantity] = total_quantity - quantity
          fulfilled = true
          break
        end
    end

    return unless fulfilled

    ActiveRecord::Base.transaction do
      candidates.each do |candidate|
        portfolio.user_base.wallet.transfer!(to: candidate[:sell].portfolio.user_base.wallet, amount: price * candidate[:quantity])
        StockTransaction.create!(
          source_portfolio_id: candidate[:sell].portfolio.id,
          target_portfolio_id: portfolio_id,
          price:,
          symbol:,
          quantity: candidate[:quantity]
        )
        candidate[:sell].update!(status: 'completed')
      end
      update!(status: 'completed', completed_at: Time.zone.now)
    end
  end

  def find_matching_to_sell
    RequestedStockTransaction
      .in_transaction_window
      .pending
      .buy
      .where(price:)
      .where("id <> ?", id)
      .order(created_at: :asc).find_each do |request|
        request.send(:find_matching_to_buy)
    end
  end

  def market_time
    start = Time.zone.now.beginning_of_day
    unless Time.zone.now > (start + MARKET_OPEN) && Time.zone.now < (start + MARKET_CLOSE)
      errors.add(:base, "market time not open yet, will open at #{start + MARKET_OPEN}. Now: #{Time.zone.now}")
    end
  end

  class << self
    def cancel_pending_request
      RequestedStockTransaction.pending.find_each do |r|
        r.update(status: "canceled")
      end
    end
  end
end
