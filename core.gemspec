require 'date'
require './lib/core/version'

Gem::Specification.new do |spec|
  spec.name        = 'virtuatable-core'
  spec.version     = Core::VERSION
  spec.date        = Date.today.strftime('%Y-%m-%d')
  spec.summary     = 'The model layer for my table-RPG application'
  spec.description = 'This gem holds the model layer for my table-top RPG games application.'
  spec.authors     = ['Vincent Courtois']
  spec.email       = 'courtois.vincent@outlook.com'
  spec.files       = Dir['lib/**/*.rb']
  spec.homepage    = 'https://rubygems.org/gems/virtuatable-core'
  spec.license     = 'MIT'

  spec.add_development_dependency 'database_cleaner', '1.6.1'
  spec.add_development_dependency 'factory_bot', '6.2.1'
  spec.add_development_dependency 'faker', '2.13.0'
  spec.add_development_dependency 'pry', '0.13.1'
  spec.add_development_dependency 'rack', '2.2.6.2'
  spec.add_development_dependency 'rack-test', '1.1.0'
  spec.add_development_dependency 'require_all', '3.0.0'
  spec.add_development_dependency 'rspec', '3.9.0'
  spec.add_development_dependency 'rspec-json_expectations', '2.1.0'
  spec.add_development_dependency 'rubocop', '0.90.0'
  spec.add_development_dependency 'simplecov', '0.19.0'
  spec.add_development_dependency 'yard', '0.9.25'

  spec.add_runtime_dependency 'activemodel', '6.0.3.2'
  spec.add_runtime_dependency 'activesupport', '6.0.3.2'
  spec.add_runtime_dependency 'bcrypt', '3.1.13'
  spec.add_runtime_dependency 'dotenv', '2.7.6'
  spec.add_runtime_dependency 'mongoid', '7.4.0'
  spec.add_runtime_dependency 'sinatra', '2.1.0'
  spec.add_runtime_dependency 'sinatra-contrib', '2.1.0'
  spec.add_runtime_dependency 'draper', '4.0.2'
end