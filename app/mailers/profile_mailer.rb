class ProfileMailer < ApplicationMailer
  default from: 'freeindianshop3@gmail.com'

  def welcome_profile
    @profile = params[:profile]
    @url  = 'http://localhost:3000/signup?profile='+@profile._id+'&invite=true'
    mail(to: @profile.email, subject: 'Invitation From xpidhi.com')
  end
end
