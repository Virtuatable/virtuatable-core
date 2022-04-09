module Core
  module Models
    # The campaigns module is holding the logic for some objects related to campaigns.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Campaigns
      autoload :Invitation, 'core/models/campaigns/invitation'
      autoload :Map       , 'core/models/campaigns/map'
      autoload :Tag       , 'core/models/campaigns/tag'
      autoload :Token     , 'core/models/campaigns/token'
      autoload :TokenPosition, 'core/models/campaigns/token_position'
    end
  end
end