class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_user_data
  helper_method :username_part, :user_email

  def after_sign_in_path_for(resource)
    if resource.is_admin
      admin_users_path
    elsif resource.is_pending
      pending_approval_path
    else
      users_portfolio_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  protected

  def keep_password(p)
    if p[:password].blank?
      p.delete(:password)
      p.delete(:password_confirmation)
    end
    p
  end

  def approve_if_admin(p)
    if p[:is_admin] == "true" || params[:is_admin] == true
      p[:is_pending] = false
    end
    p
  end

  private

    def set_user_data
      @current_user_email = current_user&.email
      @current_user_username = username_part
      @current_user_name = "#{current_user&.first_name} #{current_user&.last_name}".strip
    end

    def username_part
      current_user&.email&.split('@')&.first
    end

    def user_email
      current_user&.email
    end
end
