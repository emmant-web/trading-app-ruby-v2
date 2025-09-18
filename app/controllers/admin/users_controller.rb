class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :approve]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.order(created_at: :desc).page(params[:page]).per(10)
  end

  def pending
    @pending_users = User.where(is_pending: true)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    processed_params = approve_if_admin(user_params.to_h)

    @user = User.new(processed_params)
    @user.balance ||= 0

    if @user.save
      redirect_to admin_user_path(@user), notice: "Trader created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    processed = keep_password(user_params.to_h)
    processed = approve_if_admin(processed)

    if @user.update(processed)
      redirect_to admin_user_path(@user), notice: "Trader updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully deleted."
  end

  def approve
    @user.update(is_pending: false)

    # Send approval email
    UserMailer.approval_email(@user).deliver_now

    redirect_to admin_users_path, notice: "Trader approved and notified!"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :balance, :is_admin, :is_pending)
  end

  def record_not_found
    redirect_to admin_users_path, alert: "User does not exist."
  end

  def invalid_foreign_key
    redirect_to admin_user_path(@user), alert: "Unable to delete. User is still referenced to a transaction."
  end
end
