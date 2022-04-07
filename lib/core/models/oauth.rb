module Core
  module Models
    # This module holds the logic for the connection of an application to our API.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module OAuth
      autoload :Application  , 'core/models/oauth/application'
      autoload :Authorization, 'core/models/oauth/authorization'
      autoload :AccessToken  , 'core/models/oauth/access_token'
      autoload :RefreshToken , 'core/models/oauth/refresh_token'
    end
  end
end