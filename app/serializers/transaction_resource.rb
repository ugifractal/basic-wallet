class TransactionResource
  include Alba::Resource

  attributes :id, :amount, :created_at

  def initialize(resource, wallet)
    @wallet = wallet
    super(resource)
  end

  attribute :type do |r|
    if r.target_wallet_id == @wallet.id
      'credit'
    elsif r.source_wallet_id == @wallet.id
      'debit'
    else
      'error'
    end
  end

  attribute :amount_float do |r|
    (r.amount / 100.00).round(2)
  end
end