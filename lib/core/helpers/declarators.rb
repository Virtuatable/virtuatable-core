# frozen_string_literal: true

module Core
  module Helpers
    # This helpers module is a bit larger than the others as it provides methods
    # to declare routes whithin a service, performing needed checks and filters.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Declarators

      # Main method to declare new routes, persisting them in the database and
      # declaring it in the Sinatra application with the needed before checks.
      #
      # @param verb [String] the HTTP method for the route.
      # @param path [String] the whole URI with parameters for the route.
      # @param options [Hash] the additional options for the route.
      def api_route(verb, path, premium: false, scopes: [], &block)
        send(verb, path) do
          scope_objects = fetch_scopes(scopes + ['data::usage'])
          appli = application(premium: premium)
          check_app_scopes(appli, scope_objects)
          check_token_scopes(token, scope_objects)
          instance_eval(&block)
        end
      end
    end
  end
end
