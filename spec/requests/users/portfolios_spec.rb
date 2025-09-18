require 'rails_helper'

RSpec.describe "Users::Portfolios", type: :request do
  let!(:user) do
    User.create!(
      first_name: "Jane",
      last_name: "Doe",
      email: "jane@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  before do
    sign_in user
  end

  describe "GET /users/portfolio" do
    it "returns http success and displays user's holdings" do
      # Create some stock holdings for the user
      Stock.create!(user: user, symbol: "AAPL", shares: 10, total_price: 1500.0)
      Stock.create!(user: user, symbol: "TSLA", shares: 5, total_price: 1200.0)

      get users_portfolio_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("AAPL")
      expect(response.body).to include("TSLA")
    end

    it "filters holdings by symbol via query param" do
      Stock.create!(user: user, symbol: "AAPL", shares: 10, total_price: 1500.0)
      Stock.create!(user: user, symbol: "TSLA", shares: 5, total_price: 1200.0)

      get users_portfolio_path, params: { q: { symbol_cont: "AAPL" } }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("AAPL")
      expect(response.body).not_to include("TSLA")
    end
  end
end
