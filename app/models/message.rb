class Message
  include Mongoid::Document
  field :body, type: String
  field :user_id, type: String
  belongs_to :conversation
  belongs_to :user
  
  #after_create {  }
  after_create :call_job

  def call_job
  	message_id = id
  	logger.debug "iiiiiiiiiiii#{message_id}"
  	MessageBroadcastJob.perform_later(message_id.to_s)
  end
end
