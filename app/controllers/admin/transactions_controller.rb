class Admin::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show; end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def record_not_found
    redirect_to admin_transactions_path, alert: "Transaction does not exist."
  end
end
