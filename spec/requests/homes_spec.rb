require 'rails_helper'

RSpec.describe "HomeController", type: :request do
  describe "GET /" do
    it "renders the landing page successfully" do
      get "/"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Access global markets, execute with precision, and grow your portfolio on a secure, intuitive platform.") # optional check
    end
  end

  describe "GET /pending_approval" do
    it "renders the pending approval page successfully" do
      get "/pending_approval"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("pending") # adjust based on actual text
    end
  end
end
