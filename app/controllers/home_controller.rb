class HomeController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :handle_invalid_foreign_key


  def index 
  end

  def pending_approval
  end


    private

   def render_not_found
    redirect_to users_portfolio_path, alert: "That page wasn't found."
  end

  def handle_invalid_foreign_key
    redirect_to users_portfolio_path, alert: "That page doesn't exist"
  end

end
