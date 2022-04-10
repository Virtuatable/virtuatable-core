module Core
  module Services
    class Base
      attr_reader :services

      def initialize(registry)
        @services = registry
      end
    end
  end
end