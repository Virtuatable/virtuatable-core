module Core
  module Decorators
    class Authorization < Core::Decorators::Base
      def to_h
        { code: object.code }
      end
    end
  end
end