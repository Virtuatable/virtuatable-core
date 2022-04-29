module Core
  module Models
    module OAuth
      # A refresh token is used when an access token is expired, to get a new one. It is then recreated for the next expiration.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class RefreshToken
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'oauth_refresh_tokens'

        # @!attribute [rw] value
        #   @return [String] the value of the token, returned to the application when built.
        field :value, type: String, default: ->{ SecureRandom.hex }
        # @!attribute [rw] used_at
        #   @return [DateTime] the date and time at which this refresh token has been useds to create a new access token.
        field :used_at, type: DateTime, default: nil

        # @!attribute [rw] authorization
        #   @return [Core::Models::OAuth::Authorization] the authorization code that issued this token to the application for this user.
        belongs_to :token, class_name: 'Core::Models::OAuth::AccessToken', inverse_of: :refresh_token

        def used?
          !used_at.nil? && used_at < DateTime.now
        end
      end
    end
  end
end