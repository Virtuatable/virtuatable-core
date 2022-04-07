# frozen_string_literal: true

module Core
  module Helpers
    module Errors
      # A not found error occurs when a user tries to reach a resource that does not exist.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class NotFound < Core::Helpers::Errors::Base
        def initialize(field:, error:)
          super(field: field, error: error, status: 404)
        end
      end
    end
  end
end
