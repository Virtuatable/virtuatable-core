# frozen_string_literal: true

module Core
  module Helpers
    module Errors
      # A bad request error is raised when the data given to a model makes this model invalid.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class BadRequest < Core::Helpers::Errors::Base
        def initialize(field:, error:)
          super(field: field, error: error, status: 400)
        end
      end
    end
  end
end
