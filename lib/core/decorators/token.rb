module Core
  module Decorators
    class Token < Core::Decorators::Base

      def to_h
        {
          token: value
        }
      end
    end
  end
end