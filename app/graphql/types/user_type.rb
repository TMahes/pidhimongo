module Types
  class UserType < Types::BaseObject
        field :id, ID, null: false
        field :fname, String, null: false
  end
end
