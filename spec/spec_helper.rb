require 'simplecov'
SimpleCov.start do
  add_filter File.join('spec', '*')
end

ENV['RACK_ENV'] = 'test'
ENV['MONGOID_ENV'] = 'test'

require 'bundler/setup'
Bundler.setup

require "rspec/json_expectations"
require 'factory_girl'
require 'faker'
require 'rack/test'
require 'database_cleaner'
require 'core'
require 'pry'
require 'require_all'

require_rel 'classes/**/*.rb'
require_rel 'support/**/*.rb'
require_rel 'shared/**/*.rb'