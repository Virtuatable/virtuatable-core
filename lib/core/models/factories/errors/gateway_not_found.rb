module Core
  module Models
    module Factories
      module Errors
        # Error raised when not gateway active and running is found in the factory.
        # @author Vincent Courtois <courtois.vincent@outlook.com>
        class GatewayNotFound < Core::Models::Utils::Errors::HTTPError

          def initialize(action:)
            super(action, 'gateway_id', 'not_found', 404)
          end
        end
      end
    end
  end
end