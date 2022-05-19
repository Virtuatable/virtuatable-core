# frozen_string_literal: true

module Core
  module Services
    # Service managing user accounts.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Accounts < Core::Services::Base
      include Singleton

      # Gets an account given the nickname of the user.
      #
      # @param username [String] the nickname the user chose at account creation.
      # @return [Core::Models::Account] the account linked to this username.
      #
      # @raise [Core::Helpers::Errors::BadRequest] if the username is not given.
      # @raise [Core::Helpers::Errors::NotFound] if the username does not exist.
      def get_by_username(username: nil, **ignored)
        require_parameters username: username
        account = Core::Models::Account.find_by(username: username)
        raise unknown_err(field: 'username') if account.nil?

        Core::Decorators::Account.new(account)
      end

      # Gets and authenticates an account using its credentials.
      #
      # @param username [String] the nickname the user chose at account creation.
      # @param password [String] the password, in clear, to identify the user with.
      # @return [Core::Decorators::Account] the account if it is correctly found.
      #
      # @raise [Core::Helpers::Errors::BadRequest] if a needed parameter is not given.
      # @raise [Core::Helpers::Errors::NotFound] if a user with this nickname is not found.
      # @raise [Core::Helpers::Errors::Forbidden] if the password does not match the user.
      def get_by_credentials(username: nil, password: nil, **ignored)
        require_parameters password: password
        account = get_by_username(username: username)

        raise forbidden_err(field: 'password', error: 'wrong') unless account.has_password?(password)

        account
      end
    end
  end
end
