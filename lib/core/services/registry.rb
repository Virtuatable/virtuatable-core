module Core
  module Services
    # The registry holds references to all the services accessible in the library. To access
    # all services and be able to manage resources easily, just instanciate the 
    class Registry
      include Singleton

      attr_reader :accounts, :sessions

      def initialize
        @accounts = Core::Services::Accounts.instance
        @sessions = Core::Services::Sessions.instance
      end
    end
  end
end