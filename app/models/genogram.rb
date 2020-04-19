class Genogram
    include Mongoid::Document
	include Mongoid::Paperclip
    #belongs_to :user, :foreign_key => :user
    belongs_to :user
    field :_id
    field :key
    field :s
    field :m
    field :f
    field :ux, type: Array
    field :vir, type: Array
    field :fname
    field :familyid
    field :lname
    field :email
    field :mobile
    field :dob
    field :dod
    field :img
    field :avatar
  has_mongoid_attached_file :avatar, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
end
