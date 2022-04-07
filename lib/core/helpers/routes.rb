# frozen_string_literal: true

module Core
  module Helpers
    # This module provides the #current_route method to get the current
    # Arkaan::Monitoring::Route object from whithin sinatra routes.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Routes
      # The currently requested API route, used to see inside the block
      # if the route is premium or not, authenticated or not.
      # @return [Arkaan::Monitoring::Route] the currently requested route.
      def current_route
        splitted = request.env['sinatra.route'].split(' ')
        verb = splitted.first.downcase
        self.class.api_routes.find do |route|
          route.verb == verb && route.path == splitted.last
        end
      end
    end
  end
end
