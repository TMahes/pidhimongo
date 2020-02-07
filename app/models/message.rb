class Message
  include Mongoid::Document
  field :body, type: String
  field :user_id, type: String
  belongs_to :conversation
  belongs_to :user
end
