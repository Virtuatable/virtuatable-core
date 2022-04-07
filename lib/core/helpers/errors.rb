# frozen_string_literal: true

module Core
  module Helpers
    # This module defines method to raise HTTP errors in the routes easily.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Errors
      autoload :Base, 'core/helpers/errors/base'
      autoload :BadRequest, 'core/helpers/errors/bad_request'
      autoload :Forbidden, 'core/helpers/errors/forbidden'
      autoload :NotFound, 'core/helpers/errors/not_found'

      # Stops the executing and raises an HTTP error in the route.
      # The message MUST be of the for <field>.<error> to be correctly parsed.
      # The action is automatically parsed from the route call and added.
      #
      # @param status [Integer] the HTTP status code the response will have
      # @param message [String] the raw message to split and format as body.
      def api_error(status, message)
        field, error = message.split('.')
        docs = settings.errors.try(field).try(error)
        errors = { status: status, field: field, error: error, docs: docs }
        halt status, errors.to_json
      end

      # Stops the execution to return a NOT FOUND response.
      # @param field [String] the field in params concerned by the error.
      # @param message [String] the message if different of "unknown".
      def api_not_found(field, message: 'unknown')
        api_error 404, "#{field}.#{message}"
      end

      # Stops the execution to return a BAD REQUEST response.
      # @param field [String] the field in params concerned by the error.
      # @param message [String] the message if different of "required".
      def api_bad_request(field, message: 'required')
        api_error 400, "#{field}.#{message}"
      end

      # Stops the execution to return a FORBIDDEN response.
      # @param field [String] the field in params concerned by the error.
      # @param message [String] the message if different of "forbidden".
      def api_forbidden(field, message: 'forbidden')
        api_error 403, "#{field}.#{message}"
      end
    end
  end
end
