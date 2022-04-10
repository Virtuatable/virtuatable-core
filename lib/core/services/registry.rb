module Core
  module Services
    # The registry holds references to all the services accessible in the library. To access
    # all services and be able to manage resources easily, just instanciate the 
    class Registry

      attr_reader :accounts, :sessions

      def initialize
        @accounts = Core::Services::Accounts.new(self)
        @sessions = Core::Services::Sessions.new(self)
      end
    end
  end
end