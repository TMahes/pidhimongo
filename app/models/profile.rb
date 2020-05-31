class Profile
	include Mongoid::Document
	include Mongoid::Paperclip
    #belongs_to :user, :foreign_key => :user
   
    field :userid
    field :regid
    field :fname
    field :lname
    field :familyname
    field :email
    field :mobile
    field :dob
    field :gender
    field :bloodgroup
    field :nVillage
    field :nTaluka
    field :nDistrict
    field :nCity
    field :nState
    field :nCountry
    field :cVillage
    field :cTaluka
    field :cCity
    field :cDistrict
    field :cState
    field :cCountry
    field :created_at
    field :updated_at
    field :relation_id
    field :relation_type
    field :familyid
    field :avatar
    field :father_name
    has_many :users
    has_one :families
#belongs_to :users
  has_mongoid_attached_file :avatar, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

def self.search(search)
	if search
		any_of({fname: /#{search}/i})
		#lname,familyname,emailid,village,city,state
     end
     end
end
