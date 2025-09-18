class Users::PortfoliosController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :handle_invalid_foreign_key

  def show
   @q = current_user.stocks.where("shares > 0").ransack(params[:q])
   @holdings = @q.result.page(params[:page]).per(5)
  end

  private

   def render_not_found
    redirect_to users_portfolio_path, alert: "That page wasn't found."
  end

  def handle_invalid_foreign_key
    redirect_to users_portfolio_path, alert: "That page doesn't exist"
  end

   def set_transaction
    @holding = Stock.find(params[:id])
  end

  def holdings_params
    params.require(:holding).permit(:symbol, :created_at, :id, :shares, :stock_name, :symbol, :total_price)
  end
end
