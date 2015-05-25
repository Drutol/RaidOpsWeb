class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    @url  = "http://148.251.194.214:9292/users/#{user.activation_token}/activate"
    mail(:to => user.email,
         :subject => "Welcome to RaidOpsWeb")
  end

  def activation_success_email(user)
    @user = user
    @url  = "http://raid-ops-web.herokuapp.com/login"
    mail(:to => user.email,
         :subject => "Your RaidOpsWeb account is now activated")
  end

  def reset_password_email(user)
    @user = User.find user.id
    @url  = "http://148.251.194.214:9292/password_resets/#{@user.reset_password_token}/edit"
    mail(:to => user.email,
         :subject => "Your RaidOpsWeb password has been reset")
  end
end
