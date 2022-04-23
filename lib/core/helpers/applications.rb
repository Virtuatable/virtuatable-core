# frozen_string_literal: true

module Core
  module Helpers
    # Helpers to get and check OAuth applications connecting the the application.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Applications
      # Looks for the application sending the API's request, and raises error if not found.
      # @param [Core::Models::OAuth::Application] the application requesting the service.
      def application(premium: false)
        return @application unless @application.nil?

        check_presence 'client_id'
        @application = application_model.find_by(client_id: params['client_id'])
        api_not_found 'client_id.unknown' if @application.nil?
        api_forbidden 'client_id.forbidden' if premium && !@application.premium

        @application
      end

      def application_model
        Core::Models::OAuth::Application
      end
    end
  end
end
