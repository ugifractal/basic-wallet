module StockPriceApi
  class Stock
    class << self
      def retrieve(symbol)
      end

      def list
        conn = StockPriceApi.create_connection
        response = conn.get("/any")
        JSON.parse(response.body)
      end
    end
  end
end
