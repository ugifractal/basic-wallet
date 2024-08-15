class WalletResource
  include Alba::Resource

  attributes :id

  attribute :balance do |r|
    r.balance
  end

  attribute :balance_float do |r|
    (r.balance / 100.0).round(2)
  end

  attribute :user do |r|
    UserBaseResource.new(r.user_base).to_h
  end
end