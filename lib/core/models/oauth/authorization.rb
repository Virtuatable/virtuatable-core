module Core
  module Models
    module OAuth
      # An OAuth authorization is granted by a user to an application to access its personal data.
      # The application then transforms it into an access token to be able to send it with
      # further requests, so that we know the user has authorized the application to access its data.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Authorization
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'oauth_authorizations'

        # @!attribute [rw] code
        #   @return [String] the value corresponding to the authentication code in the RFC of OAuth2.0, kep for historic purpose.
        field :code, type: String, default: ->{ SecureRandom.hex }
        # @!attribute [rw] expiration
        #   @return [Integer] the time, in seconds, after which the authorization is declared expired.
        field :expiration, type: Integer, default: 60

        # @!attribute [rw] account
        #   @return [Arkaaan::Account] the account granting the authorization to access its data to the application.
        belongs_to :account, class_name: 'Core::Models::Account', inverse_of: :authorizations
        # @!attribute [rw] application
        #   @return [Core::Models::OAuth::Application] the application asking to access account's data.
        belongs_to :application, class_name: 'Core::Models::OAuth::Application', inverse_of: :authorizations
        # @!attribute [rw] token
        #   @return [Core::Models::OAuth::AccessToken] the access token used further in the application process to access private data of the account.
        has_many :tokens, class_name: 'Core::Models::OAuth::AccessToken', inverse_of: :authorization
        # @!attribute [rw]
        #   @return [Array<Core::Models::OAuth::Scope>] the scopes this access token has.
        has_and_belongs_to_many :scopes, class_name: 'Core::Models::OAuth::Scope', inverse_of: :authorizations

        validates :code,
          presence: {message: 'required'},
          uniqueness: {message: 'uniq'}

        # Checks if the current date is inferior to the creation date + expiration period
        # @return [Boolean] TRUE if the authorization is expired, FALSE otherwise.
        def expired?
          created_at.to_time.to_i + expiration < Time.now.to_i
        end

        def used?
          tokens.count > 0
        end
      end
    end
  end
end