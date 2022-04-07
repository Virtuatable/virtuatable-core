module Core
  module Models
    module Monitoring
      # A service is the representation of one of the applications composing the API.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Service
        include Mongoid::Document
        include Mongoid::Timestamps
        include Core::Models::Concerns::Activable
        include Core::Models::Concerns::Diagnosticable
        include Core::Models::Concerns::Premiumable

        # @!attribute [rw] key
        #   @return [String] the name of the service, used as a namespace on the Kubernetes side.
        field :key, type: String
        # @!attribute [rw] path
        #   @return [String] the path the service will be mapped on in the API. This will be used in the Ingress.
        field :path, type: String, default: '/'

        # @!attribute [rw] creator
        #   @return [Core::Models::Account] the creator of this service.
        belongs_to :creator, class_name: 'Core::Models::Account', optional: true, inverse_of: :services
        # @!attribute [rw] routes
        #   @return [Array<Core::Models::Monitoring::Route>] the routes associated to this service, accessible from the gateway.
        has_many :routes, class_name: 'Core::Models::Monitoring::Route', inverse_of: :service

        validates :key, uniqueness: {message: 'uniq'}

        validates :path, format: {with: /\A(\/:?[a-z]+)+\z/, message: 'pattern'}
      end
    end
  end
end