# you can run this test with "bundle exec rspec"


require 'rails_helper'

RSpec.describe "User Authentication", type: :request do
  describe "Sign up (registration)" do
    it "registers a user and redirects to pending approval page" do
      post user_registration_path, params: {
        user: {
          first_name: "Alice",
          last_name: "Smith",
          email: "alice@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }

      # Check if user was actually created with is_pending true
      user = User.find_by(email: "alice@example.com")
      expect(user).to be_present
      expect(user.is_pending).to eq(true)
      expect(user.is_admin).to eq(false)

      expect(response).to redirect_to(pending_approval_path)
    end
  end

  describe "Log in" do
    let!(:user) do
      User.create!(
        first_name: "John",
        last_name: "Doe",
        email: "john@example.com",
        password: "securepass",
        password_confirmation: "securepass",
        is_pending: true,
        is_admin: false
      )
    end

    it "logs in and redirects to pending approval page" do
      post user_session_path, params: {
        user: {
          email: "john@example.com",
          password: "securepass"
        }
      }

      expect(response).to redirect_to(pending_approval_path)
    end
  end
end
