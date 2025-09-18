require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # Use an anonymous controller to access ApplicationController behavior
  controller do
    def index
      render plain: "Hello"
    end
  end

  let(:admin) do
    User.create!(
      first_name: "admin",
      last_name: "user",
      email: "admin@example.com",
      password: "password",
      is_admin: true,
      balance: 0
    )
  end

  let(:pending_user) do
    User.create!(
      first_name: "pending",
      last_name: "user",
      email: "pending@example.com",
      password: "password",
      is_pending: true,
      is_admin: false
    )
  end

  let(:regular_user) do
    User.create!(
      first_name: "regular",
      last_name: "user",
      email: "user@example.com",
      password: "password",
      is_pending: false,
      is_admin: false
    )
  end

  describe "#after_sign_in_path_for" do
    it "redirects admin to admin_users_path" do
      expect(controller.after_sign_in_path_for(admin)).to eq(admin_users_path)
    end

    it "redirects pending user to pending_approval_path" do
      expect(controller.after_sign_in_path_for(pending_user)).to eq(pending_approval_path)
    end

    it "redirects regular user to users_portfolio_path" do
      expect(controller.after_sign_in_path_for(regular_user)).to eq(users_portfolio_path)
    end
  end

  describe "#after_sign_out_path_for" do
    it "redirects to root path" do
      expect(controller.after_sign_out_path_for(:user)).to eq(root_path)
    end
  end
end
