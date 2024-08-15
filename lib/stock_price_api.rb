require "stock_price_api/stock"

module StockPriceApi
  @@api_key = nil

  def self.api_key=(key)
    @@api_key = key
  end

  def self.api_key
    @@api_key
  end

  def self.create_connection
    default_header = {
      "Content-Type" => "application/json",
      "x-rapidapi-key" => api_key,
      "x-rapidapi-host" => "latest-stock-price.p.rapidapi.com"
    }
    conn = Faraday.new(
      url: "https://latest-stock-price.p.rapidapi.com",
      headers: default_header,
    ) do |faraday|
      faraday.ssl.verify = false
    end
    conn
  end
end
