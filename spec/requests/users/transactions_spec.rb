# spec/requests/users/transactions_spec.rb
require 'rails_helper'

RSpec.describe "Users::Transactions", type: :request do
  let!(:user) do
    User.create!(
      first_name: "Alice",
      last_name: "Doe",
      email: "alice@example.com",
      password: "password123",
      password_confirmation: "password123",
      balance: 5000.0
    )
  end

  before do
    sign_in user

    # Mocking API responses
    allow(AlphaApi).to receive(:get_stock_price).and_return({
      "Meta Data" => { "2. Symbol" => "AAPL" },
      "Time Series (Daily)" => {
        "2025-07-29" => { "1. open" => "100.0" }
      }
    })

    allow(AlphaApi).to receive(:get_company_name).and_return("APPL")
  end

  describe "GET /users/transactions/new" do
    # test 1: Loading the new transaction form with stock info
    it "returns stock data from AlphaApi" do
      get new_users_transaction_path, params: { symbol: "AAPL" }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("AAPL")
    end
  end

  describe "POST /users/transactions" do
    # test 2: Buying shares with enough balance
    context "when buying shares with sufficient balance" do
      it "creates a transaction and updates portfolio and balance" do
        post users_transactions_path, params: {
          symbol: "AAPL",
          price: 100.0,
          shares: 10,
          commit: "Buy"
        }

        expect(user.transactions.count).to eq(1)
        expect(user.transactions.last.action).to eq("buy")
        expect(response).to redirect_to(users_portfolio_path)
        expect(user.reload.balance).to eq(4000.0)
        expect(Stock.last.symbol).to eq("AAPL")
        expect(Stock.last.shares).to eq(10)
      end
    end

    # test 3: Buying shares without enough balance
    context "when buying shares with insufficient balance" do
      it "does not allow the transaction" do
        post users_transactions_path, params: {
          symbol: "AAPL",
          price: 1000.0,
          shares: 10,
          commit: "Buy"
        }

        expect(user.transactions.count).to eq(0)
        expect(response).to redirect_to(new_users_transaction_path(symbol: "AAPL"))
        expect(flash[:alert]).to eq("Insufficient balance.")
      end
    end

    # test 4: Selling shares that the user owns
    context "when selling shares with enough owned shares" do
      before do
        user.stocks.create!(symbol: "AAPL", shares: 10, total_price: 1000.0)
      end

      it "creates a sell transaction and updates stock and balance" do
        post users_transactions_path, params: {
          symbol: "AAPL",
          price: 100.0,
          shares: 5,
          commit: "Sell"
        }

        expect(user.transactions.last.action).to eq("sell")
        expect(response).to redirect_to(users_portfolio_path)
        expect(user.reload.balance).to eq(5500.0)
        expect(user.stocks.find_by(symbol: "AAPL").shares).to eq(5)
      end
    end

    # test 5: Selling more shares than the user owns
    context "when selling more shares than owned" do
      before do
        user.stocks.create!(symbol: "AAPL", shares: 2, total_price: 200.0)
      end

      it "does not allow the transaction" do
        post users_transactions_path, params: {
          symbol: "AAPL",
          price: 100.0,
          shares: 5,
          commit: "Sell"
        }

        expect(user.transactions.count).to eq(0)
        expect(response).to redirect_to(new_users_transaction_path(symbol: "AAPL"))
        expect(flash[:alert]).to eq("Not enough shares to sell.")
      end
    end
  end
end
