# frozen_string_literal: true

module Core
  module Services
    # Service managing authorization codes. These codes represent the access a user
    # is giving to an application on all or part of its data.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Authorizations < Core::Services::Base
      include Singleton

      # Creates an authorization to access to the data of the user for the application. The user is
      # identified by the UUID of its current connection session.
      # [WARNING] this method should NOT be used outside of the authentication backend.
      #
      # @param session_id [String] the unique identifier of the current session of the user.
      # @param client_id [String] the unique public identifier of the application.
      # @return [Code::Decorators::Authorization] the created authorization
      #
      # @raise [Core::Helpers::Errors::BadRequest] if any of the parameters is not given
      # @raise [Core::Helpers::Errors::NotFound] if the session or the application is not found
      def create_from_session(session_id: nil, client_id: nil, **ignored)
        session = Core.svc.sessions.get_by_id(session_id: session_id)
        application = Core.svc.applications.get_by_id(client_id: client_id)
        authorization = Core::Models::OAuth::Authorization.create(
          account: session.account,
          application: application
        )
        Core::Decorators::Authorization.new(authorization)
      end

      # Gets the authorization code corresponding to the provided value if it is linked to the
      # application matching the provided credentials. Otherwise it raises errors.
      #
      # @param client_id [String] the UUID of the application.
      # @param client_secret [String] the password of the application.
      # @param authorization_code [String] the code of the authorization you're trying to get.
      #
      # @return [Core::Models::OAuth::Authorization] the authorization code object if found.
      #
      # @raise [Core::Helpers::Errors::NotFound] if the application or the authorization is unknown
      # @raise [Core::Helpers::Errors::BadRequest] if any parameter is nil.
      # @raise [Core::Helpers::Errors::Forbidden] if the secret does not match the application,
      #   or the authorization code does not belong to the application.
      def get_by_credentials(client_id: nil, client_secret: nil, authorization_code: nil, **_ignored)
        require_parameters authorization_code: authorization_code
        application = Core.svc.applications.get_by_credentials(
          client_id: client_id,
          client_secret: client_secret
        )
        authorization = get_by_code(authorization_code: authorization_code)
        raise mismatch_error if authorization.application.id.to_s != application.id.to_s

        authorization
      end

      # Gets an authorization code by its corresponding value.
      # @param authorization_code [String] the code value of the authorization object.
      # @return [Core::Models::OAuth::Authorization] the authorization object.
      # @raise [Core::Helpers::Errors::NotFound] if the authorization code is not found.
      def get_by_code(authorization_code: nil, **_ignored)
        require_parameters authorization_code: authorization_code
        authorization = Core::Models::OAuth::Authorization.find_by(code: authorization_code)
        raise unknown_err(field: 'authorization_code') if authorization.nil?

        Core::Decorators::Authorization.new(authorization)
      end

      private

      def mismatch_error
        bad_request_err(field: 'client_id', error: 'mismatch')
      end
    end
  end
end
