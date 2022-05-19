module Core
  module Decorators
    class Application < Core::Decorators::Base
      def to_h
        {
          client_id: client_id,
          name: name,
          premium: premium
        }
      end

      def has_secret?(secret)
        object.client_secret == secret
      end
    end
  end
end