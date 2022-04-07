# frozen_string_literal: true

module Core
  module Helpers
    # This helpers module is a bit larger than the others as it provides methods
    # to declare routes whithin a service, performing needed checks and filters.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Declarators
      # @!attribute [r] routes
      #   @return [Array<Arkaan::Monitoring::Route>] the currently declared routes.
      attr_reader :api_routes

      # Main method to declare new routes, persisting them in the database and
      # declaring it in the Sinatra application with the needed before checks.
      #
      # @param verb [String] the HTTP method for the route.
      # @param path [String] the whole URI with parameters for the route.
      # @param options [Hash] the additional options for the route.
      def api_route(verb, path, options: {}, &block)
        options = default_options.merge(options)
        route = add_route(verb: verb, path: path, options: options)

        # TODO : do everything in the #send itself to avoid
        # route reload issues when premium is changed. It will
        # add some treatments but avoid many problems if route.premium
        send(route.verb, route.path) do
          application(premium: current_route.premium)
          session if current_route.authenticated
          instance_eval(&block)
        end
      end

      # Add a route to the database, then to the routes array.
      # @param verb [String] the HTTP method used to request this route.
      # @param path [String] the path used to request this route.
      # @return [Arkaan::Monitoring::Route] the created route.
      def add_route(verb:, path:, options:)
        route = Arkaan::Monitoring::Route.find_or_create_by!(
          path: path,
          verb: verb.downcase,
          premium: options[:premium],
          authenticated: options[:authenticated]
        )
        api_routes.nil? ? @api_routes = [route] : push_route(route)
        add_permissions(route)
        route
      end

      # Pushes the route in the api routes list, by creating it if needed
      # @param route [Arkaan::Monitoring::Route] the route to push in the list of routes.
      def push_route(route)
        @api_routes << route if api_routes.none? do |tmp_route|
          route.id == tmp_route.id
        end
      end

      # Add the default access permissions to a route. Any group tagged superuser
      # can automatically access any newly declared_route.
      # params route [Arkaan::Monitoring::Route] the route to add the permissions to.
      def add_permissions(route)
        groups = Arkaan::Permissions::Group.where(is_superuser: true)
        groups.each do |group|
          unless route.groups.where(id: group.id).exists?
            route.groups << group
            route.save!
          end
        end
      end

      # The default options for a route, being the most used value for each key.
      # @return [Hash] the default options as a hash.
      def default_options
        {
          # If TRUE the application MUST be premium to access the route.
          # Mainly used to protect administration routes against illegal accesses.
          premium: false,
          # If TRUE the user MUST be authenticated to access the route.
          authenticated: true
        }
      end
    end
  end
end
