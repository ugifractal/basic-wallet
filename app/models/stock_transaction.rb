class StockTransaction < ApplicationRecord
  validates :symbol, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }
end