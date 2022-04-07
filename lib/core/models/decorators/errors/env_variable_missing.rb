module Core
  module Models
    module Decorators
      module Errors
        # Error raised if the application key variable is missing.
        # @author Vincent Courtois <courtois.vincent@outlook.com>
        class EnvVariableMissing < Core::Models::Utils::Errors::HTTPError

          def initialize(action:)
            super(action, 'app_key', 'not_found', 404)
          end
        end
      end
    end
  end
end