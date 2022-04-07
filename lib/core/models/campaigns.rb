module Core
  module Models
    # The campaigns module is holding the logic for some objects related to campaigns.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Campaigns
      autoload :Invitation, 'core/models/campaigns/invitation'
      autoload :Tag       , 'core/models/campaigns/tag'
    end
  end
end