# frozen_string_literal: true

require 'bcrypt'
require 'securerandom'

module Core
  module Services
    # Service concerning sessions (log in and log out)
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Sessions
      include Singleton
      # Creates a new session from the given user credentials. IT will
      # * check that the user exists in the database
      # * check that the password matches the user encrypted password
      # If both steps are correctly passed, it will create and return
      # a session object so that the user can have a login token.
      #
      # @param username [string] the name of the user trying to log in
      # @param password [string] the password the user has provided
      # @return [Core::Models::Authentication::Session] the login session
      def create(username, password)
        account = Core.svc.accounts.get_by_username(username)
        if BCrypt::Password.new(account.password_digest) != password
          raise Core::Helpers::Errors::Forbidden.new(field: 'password', error: 'wrong')
        end

        Core::Models::Authentication::Session.create(
          account: account,
          token: SecureRandom.uuid
        )
      end
    end
  end
end
