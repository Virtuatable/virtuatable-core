module Core
  module Decorators
    class Campaign < Draper::Decorator
      delegate_all

      def to_simple_h
        {
          id: id.to_s,
          title: title,
          description: description,
          tags: tags,
          players: {
            current: invitations.where(status: :accepted).count,
            max: max_players
          }
        }
      end
    end
  end
end