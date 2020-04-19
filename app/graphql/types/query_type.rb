module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :all_families, [Types::FamilyType], null: false
        def all_families
            Family.all
        end
  end
end
