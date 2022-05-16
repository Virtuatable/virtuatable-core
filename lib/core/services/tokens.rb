module Core
  module Services
    class Tokens < Core::Services::Base
      include Singleton

      def create_from_authorization(client_id: nil, client_secret: nil, authorization_code: nil, **ignored)
        authorization = Core.svc.authorizations.get_by_credentials(
          client_id: client_id,
          client_secret: client_secret,
          authorization_code: authorization_code
        )
        Core::Models::OAuth::AccessToken.create(authorization: authorization)
      end

      def create_from_token(client_id: nil, client_secret: nil, token: nil, **ignored)
        application = Core.svc.applications.get_by_credentials(
          client_id: client_id,
          client_secret: client_secret
        )
        token = get_by_value(token: token)
        token_client_id = token.authorization.application.client_id
        raise bad_request_err(field: 'client_id', error: 'mismatch') if token_client_id != client_id
        Core::Models::OAuth::AccessToken.create(generator: token)
      end

      def get_by_value(token: nil, **ignored)
        token = Core::Models::OAuth::AccessToken.find_by(value: token)
        raise unknown_err(field: 'token') if token.nil?
        token
      end
    end
  end
end