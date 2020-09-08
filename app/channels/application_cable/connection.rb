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

        if verified_user = env['warden'].user
          verified_user
        else
          reject_unauthorized_connection
        end
      end

      def bs64
        decoder = Rack::Session::Cookie::Base64.new
        decoded = decoder.decode(cookies["rack.session"].split('--').first)
        HashWithIndifferentAccess.new(Marshal.load(decoded))
      end
  end
end