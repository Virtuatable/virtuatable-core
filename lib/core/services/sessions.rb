# frozen_string_literal: true

require 'bcrypt'
require 'securerandom'

module Core
  module Services
    # Service concerning sessions (log in and log out)
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Sessions < Core::Services::Base
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
      def create_from_credentials(username: nil, password: nil, **ignored)
        account = Core.svc.accounts.get_by_credentials(
          username: username,
          password: password
        )
        session = Core::Models::Authentication::Session.create(
          account: account,
          token: SecureRandom.uuid
        )
        Decorators::Session.new(session)
      end

      # Gets the session by its unique identifier.
      #
      # @param session_id [String] the unique identifier of the session you're searching.
      # @return [Core::Decorators::Session] the decorated session to display in the API.
      #
      # @raise [Core::Helpers::Errors::BadRequest] if the session ID is not given or nil
      # @raise [Core::Helpers::Errors::NotFound] if no session with its ID exist in the database.
      def get_by_id(session_id: nil, **ignored)
        require_parameters session_id: session_id
        session = Core::Models::Authentication::Session.find_by(token: session_id)
        raise unknown_err(field: 'session_id') if session.nil?

        Core::Decorators::Session.new(session)
      end
    end
  end
end
