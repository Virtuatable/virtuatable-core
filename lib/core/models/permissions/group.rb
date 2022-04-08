module Core
  module Models
    module Permissions
      # A group gathers one or several users to give them the same rights for conviniency purposes.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Group
        include Mongoid::Document
        include Mongoid::Timestamps
        include Core::Models::Concerns::Sluggable

        store_in collection: 'groups'

        # @!attribute [rw] is_default
        #   @return [Boolean] a boolean indicating whether this group is given when a new user registered or not.
        field :is_default, type: Boolean, default: false
        # @!attribute [rw] is_superuser
        #   @return [Boolean] a boolean indicating whether this group should have access to all groups and rights or not.
        field :is_superuser, type: Boolean, default: false

        # @!attribute [rw] accounts
        #   @return [Array<Core::Models::Account>] the accounts having the rights granted by this group.
        has_and_belongs_to_many :accounts, class_name: 'Core::Models::Account', inverse_of: :groups
        # @!attribute [rw] rights
        #   @return [Array<Core::Models::Permissions::Right>] the rights granted by belonging to this group.
        has_and_belongs_to_many :rights, class_name: 'Core::Models::Permissions::Right', inverse_of: :groups
        # @!attribute [rw] routes
        #   @return [Array<Core::Models::Monitoring::Route>] the routes this group can access in the API.
        has_and_belongs_to_many :routes, class_name: 'Core::Models::Permissions::Route', inverse_of: :groups

        make_sluggable 'group'
      end
    end
  end
end