class PortfolioResource
  include Alba::Resource

  attributes :id

  attribute :stocks do |r|
    bought = r.stock_transactions.where(target_portfolio_id: r.id).group(:symbol).sum(:quantity)
    sold = r.stock_transactions.where(source_portfolio_id: r.id).group(:symbol).sum(:quantity)

    calculated = bought
    bought.each do |k, v|
      calculated[k] = v - sold[k] if sold[k]
    end
    calculated
  end
end
