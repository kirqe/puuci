class NotificationWorker
  include Sidekiq::Worker

  def perform(data)
    data = HashWithIndifferentAccess.new(data)

    LiteCable.broadcast("room_global", { 
      user: data[:user], 
      message: { 
        type: data[:message][:type], 
        resource: data[:message][:resource]
      }
    })
  end
end