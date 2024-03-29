module Core
  module Models
    module OAuth
      # An application is what is referred to in the OAuth2.0 RFC as a client, wanting to access private informations about the user.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Application
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'oauth_applications'

        # @!attribute [rw] name
        #   @return [String] the unique name of the application, mainly used to identify and display it.
        field :name, type: String
        # @!attribute [rw] client_id
        #   @return [String] the unique key for the application, identifying it when requesting a token for the API.
        field :client_id, type: String, default: ->{ SecureRandom.hex }
        # @!attribute [rw] client_secret
        #   @return [String] the "password" of the application, used to identify it when requesting tokens.
        field :client_secret, type: String, default: ->{ SecureRandom.hex }
        # @!attribute [rw] premium
        #   @return [Boolean] a value indicating whether the application should automatically receive a token when an account is created, or not.
        field :premium, type: Mongoid::Boolean, default: false
        # @!attirbute [rw] redirect_uris
        #   @return [Array<String>] the redirection URIs used for this application.
        field :redirect_uris, type: Array, default: []

        # @!attribute [rw] creator
        #   @return [Core::Models::Account] the account that has created this application, considered its owner.
        belongs_to :creator, class_name: 'Core::Models::Account', inverse_of: :applications
        # @!attribute [rw] authorizations
        #   @return [Array<Core::Models::OAuth::Authorization>] the authorizations linked to the accounts this application can get the data from.
        has_many :authorizations, class_name: 'Core::Models::OAuth::Authorization', inverse_of: :application
        # @!attribute [rw]
        #   @return [Array<Core::Models::OAuth::Scope>] the scopes this application will transmit to its token
        has_and_belongs_to_many :scopes, class_name: 'Core::Models::OAuth::Scope', inverse_of: :applications

        validates :name,
          presence: {message: 'required'},
          length: {minimum: 6, message: 'minlength'},
          uniqueness: {message: 'uniq'}

        validates :client_id,
          presence: {message: 'required'},
          uniqueness: {message: 'uniq'}

        validates :client_secret,
          presence: {message: 'required'}

        validate :redirect_uris_values

        # Checks the URIs to get sure they are correct, a URI is correct if :
        # - it is a string
        # - it has a correct URL format.
        def redirect_uris_values
          redirect_uris.each do |uri|
            if !uri.is_a? String
              errors.add(:redirect_uris, 'type')
              break
            elsif uri.match(/\Ahttps?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)\z/).nil?
              errors.add(:redirect_uris, 'format')
              break
            end
          end
        end
      end
    end
  end
end