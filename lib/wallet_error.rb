class WalletError < StandardError
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def message
    @data
  end
end
