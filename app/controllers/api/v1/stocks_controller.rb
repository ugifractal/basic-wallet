module Api
  module V1
    class StocksController < ApplicationController
      before_action :authenticate_api

      def info
        StockPriceApi.api_key = "a1cad03b4fmsh48357b5f6670341p151d54jsn810385c5df9a"
        list = StockPriceApi::Stock.list

        render json: { info: list.find { |x| x["identifier"] == params[:symbol] } }
      end
    end
  end
end
