require 'rails_helper'

RSpec.describe "Admin::Transactions", type: :request do
  let!(:user) { User.create!(first_name: "Benedict", last_name: "Cumberbatch", email: "BC@example.com", password: "password", is_pending: false, balance: 100000) }
  let!(:transaction) { Transaction.create!(user: user, symbol: "AAPL", quantity: 100, action: "buy") }


  describe "GET /admin/transactions" do
    it "returns success" do
      get admin_transactions_path
      expect(response).to have_http_status(:success)
    end

    it "filters transactions using ransack" do
      get admin_transactions_path, params: { q: { transaction_type_eq: "buy" } }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/transactions/:id" do
    it "shows a transaction" do
      get admin_transaction_path(transaction)
      expect(response).to have_http_status(:success)
    end

    it "redirects if transaction not found" do
      get admin_transaction_path(99999)
      expect(response).to redirect_to(admin_transactions_path)
      follow_redirect!
      expect(response.body).to include("Transaction does not exist.")
    end
  end
end
