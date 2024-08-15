module Api
  module V1
    class PortfoliosController < ApplicationController
      before_action :authenticate_api

      def show
        render json: { portfolio: PortfolioResource.new(@current_user.portfolio).to_h }
      end

      def request_to_sell
        portfolio = @current_user.portfolio
        portfolio.request_to_sell(symbol: params[:symbol], quantity: params[:quantity], price: params[:price])
        render json: {
          requested_stock_transactions: portfolio.requested_stock_transactions.in_transaction_window.map { |x| RequestedStockTransactionResource.new(x).to_h }
        }
      rescue ActiveRecord::RecordInvalid, WalletError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def request_to_buy
        portfolio = @current_user.portfolio
        portfolio.request_to_buy(symbol: params[:symbol], quantity: params[:quantity], price: params[:price])
        render json: {
          requested_stock_transactions: portfolio.requested_stock_transactions.in_transaction_window.map { |x| RequestedStockTransactionResource.new(x).to_h }
        }
      rescue ActiveRecord::RecordInvalid, WalletError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def latest_transactions
        portfolio = @current_user.portfolio
        render json: {
          requested_stock_transactions: portfolio.requested_stock_transactions.in_transaction_window.map { |x| RequestedStockTransactionResource.new(x).to_h }
        }
      end
    end
  end
end
