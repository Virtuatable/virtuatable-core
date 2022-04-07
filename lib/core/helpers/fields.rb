# frozen_string_literal: true

module Core
  module Helpers
    # Helpers for the parameters of a request.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Fields
      # Checks the presence of several fields given as parameters and halts the execution if it's not present.
      # @param fields [Array<String>] an array of fields names to search in the parameters
      def check_presence(*fields)
        fields.each do |field|
          api_bad_request "#{field}.required" unless field_defined?(field)
        end
      end

      # Checks the presence of either fields given in parameters.
      # It halts with an error only if ALL parameters are not given.
      #
      # @param fields [Array<String>] an array of fields names to search in the parameters
      # @param key [String] the key to search in the errors configuration file.
      def check_either_presence(*fields, key:)
        api_bad_request "#{key}.required" if fields.none? do |field|
          field_defined?(field)
        end
      end

      # Checks if a given field is defined in the params
      # @param field [String] the name of the field to check in the params
      # @return [Boolean] TRUE if the field exists, FALSE otherwise.
      def field_defined?(field)
        !params.nil? && params.key?(field) && params[field] != ''
      end
    end
  end
end
