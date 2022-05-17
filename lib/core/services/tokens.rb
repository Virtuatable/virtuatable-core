# frozen_string_literal: true

module Core
  module Services
    # Service handling every operations concerning access tokens. This should mainly be
    # used in the authentication backend as we should be the only ones to manage tokens.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Tokens < Core::Services::Base
      include Singleton

      def create_from_authorization(client_id: nil, client_secret: nil, authorization_code: nil, **_ignored)
        authorization = Core.svc.authorizations.get_by_credentials(
          client_id: client_id,
          client_secret: client_secret,
          authorization_code: authorization_code
        )
        Core::Models::OAuth::AccessToken.create(authorization: authorization)
      end

      # Refreshes the token for the next request the client wants to issue by re-creating it
      # from the previous token to add it to the tokens chain.
      #
      def create_from_token(client_id: nil, client_secret: nil, token: nil, **_ignored)
        application = Core.svc.applications.get_by_credentials(client_id: client_id, client_secret: client_secret)
        token = get_by_value(token: token)
        token_client_id = token.authorization.application.client_id
        raise bad_request_err(field: 'client_id', error: 'mismatch') if token_client_id != application.client_id

        raise forbidden_err(field: 'token', error: 'used') unless token.generated.nil?

        Core::Models::OAuth::AccessToken.create(generator: token)
      end

      def get_by_value(token: nil, **_ignored)
        require_parameters token: token
        token = Core::Models::OAuth::AccessToken.find_by(value: token)
        raise unknown_err(field: 'token') if token.nil?

        token
      end
    end
  end
end
