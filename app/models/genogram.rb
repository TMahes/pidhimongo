class Genogram
    include Mongoid::Document
	include Mongoid::Paperclip
	include Mongoid::Attributes::Dynamic
 
    field :_id
    field :key, type: Integer
    field :s
    field :m
    field :f
    field :ux, type: Array
    field :vir, type: Array
    field :fname
    field :familyid
    field :invite, type: Boolean
    field :lname
    field :oname
    field :email
    field :mobile
    field :dob
    field :isalive, type: Boolean
    field :img
    field :sibling, type: String
    field :avatar
  has_mongoid_attached_file :avatar, styles: { medium: "300x300", thumb: "100x100" }, default_url: "/images/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
end
