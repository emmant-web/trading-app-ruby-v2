class UserMailer < ApplicationMailer
  default from: "no-reply@tradenova.com"

  def approval_email(user)
    @user = user
    mail(to: @user.email, subject: "Your account has been approved!")
  end

  def pending_email(user)
    @user = user
    mail(to: @user.email, subject: "Your account is pending for approval")
  end
end
