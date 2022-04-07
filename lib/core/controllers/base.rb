# frozen_string_literal: true
require 'sinatra/config_file'
require 'sinatra/custom_logger'

module Core
  module Controllers
    # This class represents a base controller for the system, giving access
    # to checking methods for sessions, gateways, applications, etc.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Base < Sinatra::Base
      register Sinatra::ConfigFile
      helpers Sinatra::CustomLogger
      # Includes the custom errors throwers and responses helpers.
      include Core::Helpers::Errors
      include Core::Helpers::Responses
      # Includes the checking methods for sessions.
      include Core::Helpers::Sessions
      # Include the checkers and getters for OAuth apps
      include Core::Helpers::Applications
      # Include checkers for field requirement and check
      include Core::Helpers::Fields
      # Include the getter for the currently requested route.
      include Core::Helpers::Routes
      # Include the getter and checkers for accounts.
      include Core::Helpers::Accounts
      # Include the loading of the parameters from the JSON body
      include Core::Helpers::Parameters
      # This module is extended, not included, because it provides routes
      # declaration methods used in class declarations.
      extend Core::Helpers::Declarators

      configure do
        set :logger, Logger.new(STDOUT)
        logger.level = Logger::ERROR if ENV['RACK_ENV'] == 'test'
        # This configuration options allow the error handler to work in tests.
        set :show_exceptions, false
        set :raise_errors, false
      end

      error Mongoid::Errors::Validations do |errors|
        key = errors.document.errors.messages.keys.first
        message = errors.document.errors.messages[key][0]
        api_bad_request key, message: message
      end

      error Virtuatable::API::Errors::NotFound do |exception|
        api_not_found exception.message
      end

      error Virtuatable::API::Errors::BadRequest do |exception|
        api_bad_request exception.message
      end

      error Virtuatable::API::Errors::Forbidden do |exception|
        api_forbidden exception.message
      end

      if ENV['RACK_ENV'] != 'test'
        error StandardError do |error|
          api_error 500, "unknown_field.#{error.class.name}"
        end
      end
    end
  end
end
