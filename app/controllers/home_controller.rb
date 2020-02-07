class HomeController < ApplicationController

  def index
  	 session[:conversations] ||= []

    @users = User.all
    @conversations = Conversation.includes(:recipient, :messages)
                                 .find(session[:conversations])
  end
end
