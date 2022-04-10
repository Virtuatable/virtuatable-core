module Core
  module Models
    module Permissions
      # A route is an endpoint accessible in the API. Each route has to have an associated endpoint in the deployed instances.
      # @param Vincent Courtois <courtois.vincent@outlook.com>
      class Route
        include Mongoid::Document
        include Mongoid::Timestamps
        include Core::Models::Concerns::Premiumable
        include Core::Models::Concerns::Activable

        store_in collection: 'routes'

        # @!attribute [rw] path
        #   @return [String] the path (URI) of the route in the API.
        field :path, type: String, default: '/'
        # @!attribute [rw] verb
        #   @return [String] the verb (HTTP method) of this route in the API.
        field :verb, type: String, default: 'get'
        # @!attribute [rw] authenticated
        #   @return [Boolean] if true, the session_id is needed for this route, if false it is not.
        field :authenticated, type: Mongoid::Boolean, default: true
        # @!attribute [rw] groups
        #   @return [Array<Core::Models::Permissions::Group>] the groups having permission to access this route.
        has_and_belongs_to_many :groups, class_name: 'Core::Models::Permissions::Group', inverse_of: :groups

        validates :path,
          format: {with: /\A(\/|((\/:?[a-zA-Z0-9_]+)+))\z/, message: 'pattern', if: :path?}

        validates :verb,
          inclusion: {message: 'unknown', in: ['get', 'post', 'put', 'delete', 'patch', 'option']}
      end
    end
  end
end