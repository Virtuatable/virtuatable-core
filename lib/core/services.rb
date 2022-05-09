# frozen_string_literal: true

module Core
  # Services are orchestrating models to provide more high-level operations.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Services
    autoload :Accounts, 'core/services/accounts'
    autoload :Registry, 'core/services/registry'
    autoload :Sessions, 'core/services/sessions'
    autoload :Campaigns, 'core/services/campaigns'
  end
end
