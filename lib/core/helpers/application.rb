# frozen_string_literal: true

module Virtuatable
  module Helpers
    # Helpers to get and check OAuth applications connecting the the application.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Applications
      # Looks for the application sending the API's request, and raises error if not found.
      # @param [Arkaan::OAuth::Application] the application requesting the service.
      def application(premium: false)
        return @application unless @application.nil?

        check_presence 'app_key'
        @application = application_model.find_by(key: params['app_key'])
        api_not_found 'app_key.unknown' if @application.nil?
        api_forbidden 'app_key.forbidden' if premium && !@application.premium

        @application
      end

      def application_model
        Arkaan::OAuth::Application
      end
    end
  end
end
