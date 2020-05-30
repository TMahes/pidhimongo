class ConversationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    @receiver = User.find_by(email:params[:user_id])
    @conversation = Conversation.get(current_user.id, @receiver._id.to_s)
    logger.debug "userrrrrrrid#{params[:user_id]}"
    add_to_conversations unless conversated?
    respond_to do |format|
      format.js
    end
  end

  def close

    @conversation = Conversation.find_by(id:params[:id])
    session[:conversations].delete(@conversation._id)
    respond_to do |format|
      format.js
    end
  end

 private
 def new
  @message = Message.new

 end
def add_to_conversations
  session[:conversations] ||= []
  session[:conversations] << @conversation._id
end

  def conversated?
    session[:conversations].include?(@conversation._id)
  end


end