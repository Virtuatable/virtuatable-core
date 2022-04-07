# frozen_string_literal: true

module Core
  # The helpers are used inside the controllers to dynamically
  # add features and functions.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Helpers
    autoload :Accounts, 'core/helpers/accounts'
    autoload :Applications, 'core/helpers/applications'
    autoload :Declarators, 'core/helpers/declarators'
    autoload :Errors, 'core/helpers/errors'
    autoload :Fields, 'core/helpers/fields'
    autoload :Parameters, 'core/helpers/parameters'
    autoload :Responses, 'core/helpers/responses'
    autoload :Routes, 'core/helpers/routes'
    autoload :Sessions, 'core/helpers/sessions'
  end
end
