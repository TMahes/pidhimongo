class HomeController < ApplicationController

=begin  def index
  	 session[:conversations] ||= []

    @users = User.all
    @conversations = Conversation.includes(:recipient, :messages)
                                 .find(session[:conversations])
  end
=end
 def index
     if params[:search].blank?
	      @profiles=Profile.all
	    else
	      @profiles=Profile.search(params[:search])
    end
    session[:conversations] ||= []

    @users = User.all
    @conversations = Conversation.includes(:recipient, :messages)
                                 .find(session[:conversations])
 end
end
