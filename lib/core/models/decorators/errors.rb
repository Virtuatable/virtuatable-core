module Core
  module Models
    module Decorators
      # Module holding all the errors concerning the code of the decorators.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module Errors
        autoload :EnvVariableMissing, 'core/models/decorators/errors/env_variable_missing'
      end
    end
  end
end