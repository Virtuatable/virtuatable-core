module Core
  module Models
    module OAuth
      # An access token is the value assigned to the application
      # to access the data the user is allowed to access.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class AccessToken
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'oauth_access_token'

        # @!attribute [rw] value
        #   @return [String] the value of the token, returned to the application when built.
        field :value, type: String, default: ->{ SecureRandom.hex }
        # @!attribute [rw] expiration
        #   @return [Integer] the time, in seconds, after which the token is declared expired, and thus can't be used anymore.
        field :expiration, type: Integer, default: 86400

        # @!attribute [rw] authorization
        #   @return [Core::Models::OAuth::Authorization] the authorization code that issued this token to the application for this user.
        belongs_to :authorization, class_name: 'Core::Models::OAuth::Authorization', inverse_of: :tokens


        # A refresh token is attached to each and every refresh token so that it can be used to deliver a new access token.
        # @!attribute [rx] refresh_token
        #   @return [Core::Models::OAuth::RefreshToken] the refresh token linked to this token
        has_one :refresh_token, class_name: 'Core::Models::OAuth::RefreshToken', inverse_of: :token

        validates :value, 
          presence: {message: 'required'},
          uniqueness: {message: 'uniq'}

        # Checks if the current date is inferior to the creation date + expiration period
        # @return [Boolean] TRUE if the token is expired, FALSE otherwise.
        def expired?
          # Handles the case where the token is given to a premium app (our apps have infinite tokens).
          return false if premium?
          return true if refresh_token.used?

          created_at.to_time.to_i + expiration < Time.now.to_i
        end

        # Returns the scopes this access token can use to access the application
        # @return [Array<Core::Models::OAuth::Scope>] the array of scopes from the linked authorization
        def scopes
          # Premium applications (our applications) have all the rights on the API.
          return Core::Models::OAuth::Scope.all.to_a if premium?

          authorization.scopes
        end

        def premium?
          authorization.application.premium
        end
      end
    end
  end
end