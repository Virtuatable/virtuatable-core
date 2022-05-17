# frozen_string_literal: true

module Core
  module Services
    class Authorizations < Core::Services::Base
      include Singleton

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
        require_parameters authorization_code
        authorization = Core::Models::OAuth::Authorization.find_by(code: authorization_code)
        raise unknown_err(field: 'authorization_code') if authorization.nil?

        authorization
      end

      private

      def mismatch_error
        bad_request_err(field: 'client_id', error: 'mismatch')
      end
    end
  end
end
