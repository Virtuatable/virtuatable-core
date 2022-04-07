module Core
  module Models
    module Chatrooms
      class Conversation < Core::Models::Chatrooms::Base
        has_many :memberships, class_name: 'Core::Models::Chatrooms::Membership', inverse_of: :chatroom
      end
    end
  end
end