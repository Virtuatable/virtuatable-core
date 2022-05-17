# frozen_string_literal: true

module Core
  module Helpers
    # Helpers to correctly build the parameters hash, even from the JSON body.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Parameters
      # Returns the parameters depending on whether the request has a body
      # or not. If it has a body, it parses it, otherwise it just returns the params.
      # @return [Hash] the parameters sent with the request.
      def params
        super.merge(body_params)
      end

      # The parameters from the JSON body if it is sent.
      # @return [Hash] the JSON body parsed as a dict ionary.
      def body_params
        request.body.rewind
        body = JSON.parse(request.body.read.to_s)
        body.map { |k, v| [k.to_sym, v] }.to_h
      rescue JSON::ParserError
        {}
      end
    end
  end
end
