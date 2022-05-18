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
        raise forbidden_err(field: 'authorization_code', error: 'used') if authorization.used?

        created = Core::Models::OAuth::AccessToken.create(authorization: authorization)
        Core::Decorators::Token.new(created)
      end

      # Refreshes the token for the next request the client wants to issue by re-creating it
      # from the previous token to add it to the tokens chain.
      #
      def create_from_token(client_id: nil, client_secret: nil, token: nil, **_ignored)
        token = get_by_value(token: token)
        authorization = Core.svc.authorizations.get_by_credentials(
          client_id: client_id,
          client_secret: client_secret,
          authorization_code: token.authorization.code
        )
        raise forbidden_err(field: 'token', error: 'used') unless token.generated.nil?

        created = Core::Models::OAuth::AccessToken.create(
          generator: token,
          authorization: authorization
        )
        Core::Decorators::Token.new(created)
      end

      def get_by_value(token: nil, **_ignored)
        require_parameters token: token
        token = Core::Models::OAuth::AccessToken.find_by(value: token)
        raise unknown_err(field: 'token') if token.nil?

        Core::Decorators::Token.new(token)
      end
    end
  end
end
