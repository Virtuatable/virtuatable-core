# frozen_string_literal: true

module Core
  module Services
    # The registry holds references to all the services accessible in the library. To access
    # all services and be able to manage resources easily, just instanciate the
    class Registry
      include Singleton

      attr_reader :accounts, :sessions, :campaigns, :applications, :authorizations

      def initialize
        @accounts = Core::Services::Accounts.instance
        @sessions = Core::Services::Sessions.instance
        @campaigns = Core::Services::Campaigns.instance
        @applications = Core::Services::Applications.instance
        @authorizations = Core::Services::Authorizations.instance
      end
    end
  end
end
