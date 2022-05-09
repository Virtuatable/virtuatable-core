# frozen_string_literal: true

%w[active_model mongoid active_support].each { |g| require g }

# Main module of the application, holding all the subsequent classes.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module Core
  autoload :Controllers, 'core/controllers'
  autoload :Helpers, 'core/helpers'
  autoload :Models, 'core/models'
  autoload :Services, 'core/services'

  # Returns the registry of services for easier access to each of them.
  def self.svc
    Core::Services::Registry.instance
  end
end
