# frozen_string_literal: true

module Core
  module Services
    # Service managing applications, allowing easy access to them with or without
    # providing client secret for example.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Applications < Core::Services::Base
      include Singleton

      # Gets an application given its credentials (client UUID and client secret).
      #
      # @param client_id [String] the unique public identifier of the application.
      # @param client_secret [String] the password for the application.
      # @return [Core::Models::OAuth::Application] the application if it has been found.
      #
      # @raise [Core::Helpers::Errors::BadRequest] if a parameter is not correctly given.
      # @raise [Core::Helpers::Errors::Forbidden] if the client secret is wrong for this application.
      # @raise [Core::Helpers::Errors::Unknown] if the application is not found.
      def get_by_credentials(client_id: nil, client_secret: nil, **_ignored)
        require_parameters client_id, client_secret
        application = get_by_id(client_id: client_id)
        raise forbidden_err(field: 'client_secret', error: 'wrong') if application.client_secret != client_secret

        application
      end

      # Gets an application given its client UUID.
      #
      # @param client_id [String] the unique identifier of the application to get
      # @return [Core::Models::OAuth::Application] the application found if no error is raised.
      #
      # @raise [Core::Helpers::Errors::Unknown] if the application is not found.
      def get_by_id(client_id: nil, **_ignored)
        require_parameters client_id
        application = Core::Models::OAuth::Application.find_by(client_id: client_id)
        raise unknown_err(field: 'client_id') if application.nil?

        application
      end
    end
  end
end
