class Family
    include Mongoid::Document
	include Mongoid::Paperclip
    #belongs_to :user, :foreign_key => :user
    field :_id
    field :id
    field :familyid
    field :pid, type: String
    field :tags, type: Array
    field :fname
    field :lname
    field :email
    field :gender
    field :mobile
    field :dob
    field :img
    field :avatar
#belongs_to :users
  has_mongoid_attached_file :avatar, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

end
