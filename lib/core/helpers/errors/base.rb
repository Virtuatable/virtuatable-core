# frozen_string_literal: true

module Core
  module Helpers
    module Errors
      # Standard class parent to all specialized http errors.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Base < StandardError
        # @!attribute [rw] field
        #   @return [String, Symbol] the name of the field in error in the model.
        attr_accessor :field
        # @!attribute [rw] action
        #   @return [String] the name of the action the user was trying to perform on the model (often crate or update).
        attr_accessor :action
        # @attribute [rw] error
        #   @return [String] the label of the error returned by the model.
        attr_accessor :error
        # @attribute [rw] status
        #   @return [Integer] the HTTP status code as a number (eg: 400, 422 or 500)
        attr_accessor :status

        def initialize(field:, error:, status:)
          @field = field.to_s
          @error = error
          @status = status
        end

        # Returns the formatted message for this exception.
        # @return [String] a message indicating what field fails, and why.
        def message
          "#{field}.#{error}"
        end
      end
    end
  end
end
