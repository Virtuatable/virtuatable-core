module Core
  module Helpers
    module Scopes

      def fetch_scopes(names)
        (names.map { |n| Core::Models::OAuth::Scope.find_by(name: n) }).select { |s| !s.nil? }
      end

      def check_token_scopes(token, scopes)
        scopes.each do |scope|
          api_forbidden 'scope.forbidden' if !token.scopes.include? scope
        end
      end

      def check_app_scopes(application, scopes)
        scopes.each do |scope|
          api_forbidden 'scope.forbidden' if !application.scopes.include? scope
        end
      end
    end
  end
end