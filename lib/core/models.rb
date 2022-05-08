# frozen_string_literal: true

module Core
  # Module holding the representations of the business objects we're manipulating
  # in the database. Models are declared as Mongoid classes to connect to MongoDB
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Models
    autoload :Account, 'core/models/account'
    autoload :Authentication, 'core/models/authentication'
    autoload :Campaign, 'core/models/campaign'
    autoload :Campaigns, 'core/models/campaigns'
    autoload :Chatroom, 'core/models/chatroom'
    autoload :Chatrooms, 'core/models/chatrooms'
    autoload :Concerns, 'core/models/concerns'
    autoload :Event, 'core/models/event'
    autoload :Files, 'core/models/files'
    autoload :Notification, 'core/models/notification'
    autoload :OAuth, 'core/models/oauth'
    autoload :Ruleset, 'core/models/ruleset'
  end
end
