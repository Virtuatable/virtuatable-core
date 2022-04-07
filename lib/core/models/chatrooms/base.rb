module Core
  module Models
    module Chatrooms
      # The base chatroom class, made to be subclassed in campaign and personal chatrooms.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Base
        include Mongoid::Document
        include Mongoid::Timestamps

        # @!attribute [rw] messages
        #   @return [Array<Core::Models::Chatrooms::Message>] the messages sent in this chatroom.
        has_many :messages, class_name: 'Core::Models::Chatrooms::Message', inverse_of: :chatroom
      end
    end
  end
end