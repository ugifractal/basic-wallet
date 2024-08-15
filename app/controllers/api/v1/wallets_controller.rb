module Api
  module V1
    class WalletsController < ApplicationController
      before_action :authenticate_api

      def show
        render json: { wallet: WalletResource.new(@current_user.wallet).to_h }
      end

      def top_up
        @current_user.wallet.top_up!(params[:amount])
        render json: { wallet: WalletResource.new(@current_user.wallet).to_h }
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def transfer
        target = UserBase.find_by(email: params[:email])
        render json: { message: "email not found" }, status: :unprocessable_entity unless target
        @current_user.wallet.transfer!(to: target, amount: params[:amount])
        render json: { wallet: WalletResource.new(@current_user.wallet).to_h }
      rescue ActiveRecord::RecordInvalid, WalletError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def transactions
        @transactions = @current_user.wallet.transactions.limit(100)
        render json: { transactions: @transactions.map { |x| TransactionResource.new(x, @current_user.wallet).to_h } }
      end
    end
  end
end