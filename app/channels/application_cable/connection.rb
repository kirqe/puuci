# frozen_string_literal: true

module ApplicationCable
  class Connection < LiteCable::Connection::Base
    identified_by :current_user

    def connect
      # self.current_user = find_verified_user
      # $stdout.puts "#{find_verified_user} connected"
    end

    def disconnect
      # $stdout.puts "#{self.current_user} disconnected"
    end

    private

    def find_verified_user
      if verified_user == env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
