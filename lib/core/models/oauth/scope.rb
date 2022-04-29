module Core
  module Models
    module OAuth
      # A scope gives access to some parts of the API, for example to the management of campaigns,
      # applications or for account profile management.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Scope
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'oauth_scopes'

        # @!attribute [rw] name
        #   @return [String] the name of the scope, used to get its translation on the frontend.
        field :name, type: String, default: ''

        # @!attribute [rw] applications
        #   @return [Array<Core::Models::OAuth::Application>] the applications that want to have access to this
        #     scope from the users of the platform. These rights will be carried on to the tokens and frozen.
        has_and_belongs_to_many :applications, class_name: 'Core::Models::OAuth::Application', inverse_of: :scopes
        # @!attribute [rw] tokeauthorizationsns
        #   @return [Array<Core::Models::OAuth::Authorization] the tokens having these scopes.
        has_and_belongs_to_many :authorizations, class_name: 'Core::Models::OAuth::Authorization', inverse_of: :scopes

        validates :name,
          presence: {message: 'required'},
          length: {minimum: 6, if: :name?, message: 'minlength'},
          uniqueness: {id: :name?, message: 'uniq'}
      end
    end
  end
end