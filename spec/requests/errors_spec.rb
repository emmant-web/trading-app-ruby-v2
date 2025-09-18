# spec/requests/errors_spec.rb
require "rails_helper"

RSpec.describe "Errors", type: :request do
  it "renders the 404 static file with 404 status" do
    get "/nonexistent-path-xyz"

    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("We couldn't find the page you were looking for.") # Adjust based on your 404.html content
  end
end
