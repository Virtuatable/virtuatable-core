require 'mongoid'
require 'active_model'
require 'active_support'
require 'dotenv/load'

# Main module of the application, holding all the subsequent classes.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module Core
  autoload :Models, 'core/models'
end