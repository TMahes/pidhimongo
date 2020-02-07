class Conversation
  include Mongoid::Document
  field :recipient_id, type: Integer
  field :sender_id, type: Integer
 
  has_many :messages, dependent: :destroy
  belongs_to :sender, foreign_key: :sender_id, class_name: User
  belongs_to :recipient, foreign_key: :recipient_id, class_name: User

  validates :sender_id, uniqueness: { scope: :recipient_id }

    scope :between, -> (sender_id, recipient_id) do
    where(sender_id: sender_id, recipient_id: recipient_id).or(
      where(sender_id: recipient_id, recipient_id: sender_id)
    )
  end

  def self.get(sender_id, recipient_id)
    conversation = find_by(sender_id: sender_id, recipient_id: recipient_id)
    if conversation.blank?
    	conversation = find_by(sender_id: recipient_id, recipient_id: sender_id)
    end
    logger.debug "senderrrrrrrr#{sender_id}"
    logger.debug "senderrrrrrrr#{recipient_id}"
    return conversation if conversation.present?

    create(sender_id: sender_id, recipient_id: recipient_id)
  end

  def opposed_user(user)
    user == recipient ? sender : recipient
  end
end
