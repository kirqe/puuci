# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
# ENV['SERVER_NAME'] = "localhost:9393"

require File.expand_path('../config/environment', __dir__)
# require File.expand_path("../../lib/sinatra/helpers", __FILE__)
require_relative '../lib/sinatra/helpers'
# require 'bundler'
# require 'sinatra'

require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'capybara/dsl'
require 'rack/test'
# require "sinatra/activerecord"
# Bundler.require(:default, :test)
# require 'will_paginate'
require 'database_cleaner'

# Capy
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

Capybara.server = :puma
Capybara.app = Rack::Builder.parse_file(File.expand_path('../config.ru', __dir__)).first
Capybara.run_server = true
Capybara.default_max_wait_time = 10
Capybara.current_driver = :selenium

def app
  Rack::Builder.parse_file(File.expand_path('../config.ru', __dir__)).first
end

# R
DatabaseCleaner.strategy = :truncation
RSpec.configure do |config|
  include Rack::Test::Methods # for things like get("/") post("..")
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.warnings = true
  config.shared_context_metadata_behavior = :apply_to_host_groups
  # config.include Capybara::DSL
  config.before(:all) do
    DatabaseCleaner.clean
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# Capybara.configure { |config| config.default_host = "http://localhost:9393" }

# Capybara.configure do |config|
#   config.run_server = false
#   config.default_driver = :selenium
#   config.app_host = 'localhost:9393' # change url
# end
# Capybara.app_host = "http://localhost:9393"
# Capybara.server_port = 9393
# Capybara.register_driver :rack_test do |app|
#   Capybara::RackTest::Driver.new(app, headers: { 'HTTP_USER_AGENT' => 'Capybara' })
# end
