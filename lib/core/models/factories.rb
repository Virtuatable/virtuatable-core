module Core
  module Models
    # Static factories are used to create decorated objects easily.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Factories
      autoload :Gateways, 'core/models/factories/gateways'
      autoload :Errors  , 'core/models/factories/errors'
    end
  end
end