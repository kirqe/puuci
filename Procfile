redis: redis-server
web:  CABLE_URL=ws://localhost:9293/cable bundle exec puma -e production
rpc:  LITECABLE_BROADCAST_ADAPTER=any_cable bundle exec anycable
ws:   anycable-go --debug --host localhost --port 9293 --broadcast_adapter=redis
sidekiq: bundle exec sidekiq -r ./config/environment.rb

