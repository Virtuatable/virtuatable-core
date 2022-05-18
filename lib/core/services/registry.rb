# frozen_string_literal: true

module Core
  module Services
    # The registry holds references to all the services accessible in the library. To access
    # all services and be able to manage resources easily, just instanciate the
    class Registry
      include Singleton

      # @!attribute [r] accounts
      #   @return [Core::Services::Accounts] the service managing accounts
      attr_reader :accounts
      # @!attribute [r] sessions
      #   @return [Core::Services::Sessions] the service managing sessions
      attr_reader :sessions
      # @!attribute [r] campaigns
      #   @return [Core::Services::Campaigns] the service managing campaigns
      attr_reader :campaigns
      # @!attribute [r] applications
      #   @return [Core::Services::Applications] the service managing applications
      attr_reader :applications
      # @!attribute [r] authorizations
      #   @return [Core::Services::Authorizations] the service managing authorizations
      attr_reader :authorizations
      # @!attribute [r] tokens
      #   @return [Core::Services::Tokens] the service managing OAuth access tokens
      attr_reader :tokens

      def initialize
        @accounts = Core::Services::Accounts.instance
        @sessions = Core::Services::Sessions.instance
        @campaigns = Core::Services::Campaigns.instance
        @applications = Core::Services::Applications.instance
        @authorizations = Core::Services::Authorizations.instance
        @tokens = Core::Services::Tokens.instance
      end
    end
  end
end
