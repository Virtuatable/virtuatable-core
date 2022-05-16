module Core
  module Services
    class Base
      # Raises an error if any parameter is nil, and nothing if all parameters are found.
      # @raise [Core::Helpers::Errors::BadRequest] an error if any parameter is nil.
      def require_parameters(*parameters)
        parameters.each do |parameter|
          raise bad_request_err(field: parameter, error: 'required') if parameter.nil?
        end
      end

      def bad_request_err(field: nil, error: nil)
        Core::Helpers::Errors::BadRequest.new(field: field, error: error)
      end

      def unknown_err(field: nil, error: 'unknown')
        Core::Helpers::Errors::NotFound.new(field: field, error: error)
      end

      def forbidden_err(field: nil, error: 'forbidden')
        Core::Helpers::Errors::Forbidden.new(field: field, error: error)
      end
    end
  end
end