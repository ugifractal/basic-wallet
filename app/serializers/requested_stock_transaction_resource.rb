class RequestedStockTransactionResource
  include Alba::Resource

  attributes :id, :transaction_type, :price, :quantity, :created_at, :status
end
