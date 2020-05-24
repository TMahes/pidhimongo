class ProfileMailer < ApplicationMailer
  default from: 'freeindianshop3@gmail.com'

  def welcome_profile(profile)
    email = params[:genogram]
    @url  = 'http://localhost:3000/signup?profile='+profile+'&invite=true'
    mail(to: email, subject: 'Invitation From xpidhi.com')
  end
end
