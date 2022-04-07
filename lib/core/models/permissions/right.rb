module Core
  module Models
    module Permissions
      # A right is the access to one or several features in the application. It's applied to a group, and transitively to an account.
      # @author Vincent Courtois <courtois;vincent@outlook.com>
      class Right
        include Mongoid::Document
        include Mongoid::Timestamps
        include Core::Models::Concerns::Sluggable

        # @!attribute [rw] groups
        #   @return [Array<Core::Models::Permissions::Group>] the groups granted with the permission to access features opened by this right.
        has_and_belongs_to_many :groups, class_name: 'Core::Models::Permissions::Group', inverse_of: :rights

        belongs_to :category, class_name: 'Core::Models::Permissions::Category', inverse_of: :rights

        make_sluggable 'right'
      end
    end
  end
end