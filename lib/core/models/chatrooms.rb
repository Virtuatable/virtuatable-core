module Core
  module Models
    # The chatrooms modules regroup all classes concerning messages between players.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Chatrooms
      autoload :Base        , 'core/models/chatrooms/base'
      autoload :Campaign    , 'core/models/chatrooms/campaign'
      autoload :Conversation, 'core/models/chatrooms/conversation'
      autoload :Message     , 'core/models/chatrooms/message'
      autoload :Membership  , 'core/models/chatrooms/membership'
    end
  end
end