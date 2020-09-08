CABLE_URL = ENV.fetch("CABLE_URL", "/cable")
#  CABLE_URL="ws://localhost:9293/cable"
require 'bundler'
Bundler.require

require 'require_all'
require "lite_cable/server"
require "anycable"
require "litecable"

require_all 'app'

# LiteCable.anycable!
LiteCable.broadcast_adapter = :any_cable
LiteCable.config.log_level = Logger::DEBUG
AnyCable.connection_factory = ApplicationCable::Connection
