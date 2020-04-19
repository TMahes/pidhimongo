module Types
  class FamilyType < Types::BaseObject
  	    field :id, ID, null: false
        field :fname, String, null: false
        field :pid, String, null: true
        field :userid,[Types::UserType], null: false
  end
end
