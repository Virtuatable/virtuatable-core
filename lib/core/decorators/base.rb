module Core
  module Decorators
    class Base < Draper::Decorator
      delegate_all

      def id
        object.id.to_s
      end

      def to_json
        to_h.to_json
      end
    end
  end
end