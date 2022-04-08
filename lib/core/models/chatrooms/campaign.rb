module Core
  module Models
    module Chatrooms
      # Represents the chatroom embedded in a campaign.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Campaign < Core::Models::Chatrooms::Base
        # @!attribute [rw] campaign
        #   @return [Core::Models::Campaign] the campaign the chatroom is linked to.
        embedded_in :campaign, class_name: 'Core::Models::Campaign', inverse_of: :chatroom
        # @!attribute [rw] messages
        #   @return [Array<Core::Models::Chatrooms::Messages>] the messages said in this conversation
        has_many :messages, class_name: 'Core::Models::Chatrooms::Message', inverse_of: :chatroom
      end
    end
  end
end