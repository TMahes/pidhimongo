class UserMailer < ApplicationMailer
	  default from: 'freeindianshop3@gmail.com'

  def welcome_email
    @user = params[:genogram]
    @url  = 'http://xpidhi.com/login'
    mail(to: @user.email, subject: 'Welcome to xpidhi.com')
  end
end
