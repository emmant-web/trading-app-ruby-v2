class Users::TransactionsController < ApplicationController
  before_action :authenticate_user!
 

  def index
    @q = current_user.transactions.ransack(params[:q])
    @transactions = @q.result.order(created_at: :desc).page(params[:page]).per(8)
  end

  def new
    if params[:symbol].present?
      data = AlphaApi.get_stock_price(params[:symbol])

      if data["Meta Data"].present? && data["Time Series (Daily)"].present?
        @symbol = data["Meta Data"].dig("2. Symbol")
        first_day_data = data["Time Series (Daily)"].values.first
        @stock_price = first_day_data["1. open"]
      else
        flash.now[:alert] = "Invalid stock symbol or data unavailable."
      end
    end
  end

  def create
    symbol = params[:symbol]
    stock_price = params[:price].to_f
    quantity = params[:shares].to_i
    action = params[:commit] # "Buy" or "Sell"
    total_price = stock_price * quantity

    if action == "Buy"
      if current_user.balance >= total_price
        current_user.transactions.create!(
          action: "buy",
          symbol: symbol.upcase,
          stock_price: stock_price,
          quantity: quantity,
          total_price: total_price
        )

        stock = current_user.stocks.find_or_initialize_by(symbol: symbol.upcase)
        stock.shares ||= 0
        stock.total_price ||= 0
        stock.stock_name ||= AlphaApi.get_company_name(symbol.upcase)

        stock.shares += quantity
        stock.total_price += total_price
        stock.save!

        current_user.update!(balance: current_user.balance - total_price)
        redirect_to users_portfolio_path, notice: "Successfully bought #{quantity} shares of #{symbol}."
      else
        redirect_to new_users_transaction_path(symbol: symbol), alert: "Insufficient balance."
      end

    elsif action == "Sell"
      owned_shares = current_user.stocks.where(symbol: symbol.upcase).first.shares

      if owned_shares >= quantity
        current_user.transactions.create!(
          action: "sell",
          symbol: symbol.upcase,
          stock_price: stock_price,
          quantity: quantity,
          total_price: total_price
        )

        stock = current_user.stocks.find_or_initialize_by(symbol: symbol.upcase)

        if stock.present?
          stock.shares -= quantity
          stock.total_price -= total_price

          if stock.shares <= 0
            stock.destroy
          else
            stock.save!
          end
        else
          puts "No matching stock found for symbol #{symbol}"
        end

        current_user.update!(balance: current_user.balance + total_price)
        redirect_to users_portfolio_path, notice: "Successfully sold #{quantity} shares of #{symbol}."
      else
        redirect_to new_users_transaction_path(symbol: symbol), alert: "Not enough shares to sell."
      end

    else
      redirect_to new_users_transaction_path, alert: "Invalid transaction type."
    end
  end

  


end
