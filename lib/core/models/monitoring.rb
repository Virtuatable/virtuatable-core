module Core
  module Models
    # The monitoring module holds all the logic about the services so they can be activated or deactivated.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Monitoring
      autoload :Route  , 'core/models/monitoring/route'
      autoload :Service, 'core/models/monitoring/service'
    end
  end
end