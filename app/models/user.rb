class User
	include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
field :name
field :email
field :mobile
field :password
field :encrypted_password
field :remember_created_at
validates_presence_of :name
validates_uniqueness_of :name, :email, :case_sensitive => false
has_many :messages
has_many :conversations, foreign_key: :sender_id

def will_save_change_to_email? 
end
  
end
