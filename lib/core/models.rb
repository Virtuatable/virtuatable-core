require 'mongoid'
require 'active_model'
require 'active_support'
require 'dotenv/load'

# Main module of the application, holding all the subsequent classes.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module Core
  module Models
    autoload :Account       , 'core/models/account'
    autoload :Authentication, 'core/models/authentication'
    autoload :Campaign      , 'core/models/campaign'
    autoload :Campaigns     , 'core/models/campaigns'
    autoload :Chatroom      , 'core/models/chatroom'
    autoload :Chatrooms     , 'core/models/chatrooms'
    autoload :Concerns      , 'core/models/concerns'
    autoload :Event         , 'core/models/event'
    autoload :Factories     , 'core/models/factories'
    autoload :Files         , 'core/models/files'
    autoload :Monitoring    , 'core/models/monitoring'
    autoload :Notification  , 'core/models/notification'
    autoload :OAuth         , 'core/models/oauth'
    autoload :Permissions   , 'core/models/permissions'
    autoload :Phone         , 'core/models/phone'
    autoload :Ruleset       , 'core/models/ruleset'
  end
end