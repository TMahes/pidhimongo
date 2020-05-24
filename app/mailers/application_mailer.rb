class ApplicationMailer < ActionMailer::Base
  default from: 'freeindianshop3@gmail.com'
  layout 'mailer'
end
class UserMailer < ApplicationMailer
end
class ProfileMailer < ApplicationMailer
end
