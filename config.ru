# frozen_string_literal: true

require_relative './config/environment'
require 'lite_cable/server'
require 'sidekiq'

require './lib/warden'
require 'warden'

# require 'securerandom'
require 'encrypted_cookie'

%w[will_paginate will_paginate/active_record].each { |lib| require lib }
require 'will_paginate/array'

# Sidekiq.configure_client do |config|
#   config.redis = { url: "redis://localhost:6379" }
# end

require 'sidekiq/web'
map '/sidekiq' do
  Sidekiq::Web.set :sessions, false
  use Rack::Auth::Basic, 'Protected Area' do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest('sidekiq')) &
      Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest('sidekiq'))
  end

  run Sidekiq::Web
end

use Rack::Session::EncryptedCookie,
    key: 'rack.session',
    expire_after: 50_000,
    secret: '40030143c5cf8e19d148f7897e184dbe69ce644d35aa5c15dde4456efdb8febb'

# Sidekiq::Web.set :sessions, domain: "localhost:9292"
# Sidekiq::Web.set :session_secret, "40030143c5cf8e19d148f7897e184dbe69ce644d35aa5c15dde4456efdb8febb"

# Sidekiq::Extensions.enable_delay!

use Rack::MethodOverride

use Warden::Manager do |manager|
  manager.serialize_into_session(&:id)
  manager.serialize_from_session { |id| User.find(id) }

  manager.scope_defaults :default,
                         # "strategies" is an array of named methods with which to
                         # attempt authentication. We have to define this later.
                         strategies: [:password],
                         # The action is a route to send the user to when
                         # warden.authenticate! returns a false answer. We'll show
                         # this route below.
                         action: '/unauthenticated'
  manager.failure_app = SessionsController
end

use SessionsController
use RegistrationsController
use Dashboard::DashboardController
use Dashboard::UsersController
use Dashboard::IssuesController

use HomeController
use UsersController
use ProjectsController
use IssuesController
use UploadsController
use CommentsController
use SearchController

run ApplicationController

ApplicationController.new do
  map '/cable' do
    use LiteCable::Server::Middleware, connection_class: ApplicationCable::Connection
    run(proc { |_| [200, { 'Content-Type' => 'text/plain' }, ['OK']] })
  end
end
