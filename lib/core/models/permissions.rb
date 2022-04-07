module Core
  module Models
    # This module holds the logic for all the classes concerning the permissions abd rights for the user.
    # A permission is restricting the access to one or several features to the users having it.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Permissions
      autoload :Right   , 'core/models/permissions/right'
      autoload :Group   , 'core/models/permissions/group'
      autoload :Category, 'core/models/permissions/category'
      autoload :Route   , 'core/models/permissions/route'
    end
  end
end