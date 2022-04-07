module Core
  module Models
    module Chatrooms
      class Membership
        include Mongoid::Document
        include Mongoid::Timestamps
        include Core::Models::Concerns::Enumerable

        enum_field :status, [:shown, :hidden], default: :shown

        belongs_to :chatroom, class_name: 'Core::Models::Chatrooms::Private', inverse_of: :memberships

        belongs_to :account, class_name: 'Core::Models::Account', inverse_of: :memberships
      end
    end
  end
end