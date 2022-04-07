module Core
  module Models
    # This module holds the shared concerns to include in the desired models.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Concerns
      autoload :Activable     , 'core/models/concerns/activable'
      autoload :Diagnosticable, 'core/models/concerns/diagnosticable'
      autoload :Enumerable    , 'core/models/concerns/enumerable'
      autoload :Historizable  , 'core/models/concerns/historizable'
      autoload :MimeTypable   , 'core/models/concerns/mime_typable'
      autoload :Premiumable   , 'core/models/concerns/premiumable'
      autoload :Sluggable     , 'core/models/concerns/sluggable'
      autoload :Typable       , 'core/models/concerns/typable'
    end
  end
end