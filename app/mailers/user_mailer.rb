class UserMailer < ApplicationMailer
	  default from: 'freeindianshop3@gmail.com'

  def welcome_email
    email = params[:profileEmail]
    @url  = 'http://localhost:3000/login'
    mail(to: email, subject: 'Welcome to xpidhi.com')
  end
end
