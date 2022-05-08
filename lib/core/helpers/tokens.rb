# frozen_string_literal: true

module Core
  module Helpers
    # This helper aims at providing vanity methods concerning OAuth tokens.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Tokens
      # Returns the database object representing the current OAuth token, or
      # raises an error if the token seems to be invalid for any reason.
      # @return [Core::Models::Oauth::AccessToken] the token if everything went well.
      # @raise [Core::Helpers::Errors::BadRequest] if the token is not given.
      # @raise [Core::Helpers::Errors::NotFound] if the token is not found in the
      #   database searching for the value passed as parameter.
      # @raise [Core::Helpers::Errors::Forbidden] if the token belongs to another
      #   application.
      def token
        return @token unless @token.nil?

        check_presence 'token'
        @token = Core::Models::OAuth::AccessToken.find_by(value: params['token'])
        api_not_found 'token.unknown' if @token.nil?
        token_app_id = token.authorization.application.id.to_s
        api_forbidden 'token.mismatch' if token_app_id != application.id.to_s
        @token
      end
    end
  end
end
