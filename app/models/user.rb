class User
	include Mongoid::Document
	include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :trackable,
         :recoverable, :rememberable, :validatable
field :name
field :email
field :mobile
field :password
field :encrypted_password
field :remember_created_at
field :familyid
field :confirmation_token, type: String
field :confirmed_at
field :confirmation_sent_at
field :confirmation_token
field :sign_in_count, type: Integer
field :current_sign_in_at
field :last_sign_in_at
field  :initial_ip
field :current_sign_in_ip
field :last_sign_in_ip
field :reset_password_token
field :reset_password_sent_at
field :from_invite, type: Boolean
validates_presence_of :name
validates_uniqueness_of  :email, :case_sensitive => false
has_many :messages
has_many :conversations, foreign_key: :sender_id

def will_save_change_to_email? 
end
  
end
