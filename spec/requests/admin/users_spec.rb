require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let!(:admin) { User.create!(first_name: "Jane", last_name: "Doe", email: "admin@example.com", password: "password", is_admin: true, is_pending: false, balance: 0) }
  let!(:trader) { User.create!(first_name: "Alice", last_name: "Doe", email: "trader@example.com", password: "password", is_admin: false, is_pending: true) }

  describe "GET /admin/users" do
    it "returns success" do
      get admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/pending" do
    it "returns success" do
      get pending_admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/:id" do
    it "shows the user" do
      get admin_user_path(trader)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/new" do
    it "renders new" do
      get new_admin_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/users" do
    it "creates a new trader and redirects" do
      expect {
        post admin_users_path, params: { user: { first_name: "John", last_name: "Doe", email: "new@example.com", password: "password", password_confirmation: "password", balance: 0 } }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to(admin_user_path(User.last))
      expect(User.last.is_pending).to eq(true)
    end

    it "creates an admin without pending status" do
      expect {
        post admin_users_path, params: { user: { first_name: "John", last_name: "Marvin", email: "newadmin@example.com", password: "password", password_confirmation: "password", is_admin: true, balance: 0 } }
      }.to change(User, :count).by(1)
      expect(User.last.is_pending).to eq(false)
    end
  end

  describe "GET /admin/users/:id/edit" do
    it "renders edit" do
      get edit_admin_user_path(trader)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /admin/users/:id" do
    it "updates user and redirects" do
      patch admin_user_path(trader), params: { user: { email: "updated@example.com" } }
      expect(response).to redirect_to(admin_user_path(trader))
      expect(trader.reload.email).to eq("updated@example.com")
    end
  end

  describe "DELETE /admin/users/:id" do
    it "destroys user and redirects" do
      user = User.create!( first_name: "Jason", last_name: "Bourne", email: "JB@example.com", password: "password", password_confirmation: "password", balance: 0 )
      expect {
        delete admin_user_path(user)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe "PATCH /admin/users/:id/approve" do
    it "approves the user and sends email" do
      allow(UserMailer).to receive_message_chain(:approval_email, :deliver_now)
      patch approve_admin_user_path(trader)
      expect(trader.reload.is_pending).to eq(false)
      expect(UserMailer).to have_received(:approval_email)
      expect(response).to redirect_to(admin_users_path)
    end
  end
end
