# require_relative "./application_cable/channel.rb"

class NotificationsChannel < ApplicationCable::Channel
  identifier :room

  def subscribed
    # reject unless room_id
    stream_from "room_#{room_id}"
  end

  def speak(data) 
    # LiteCable.broadcast "room_#{room_id}", user: user, message: data["message"]#, sid: sid
  end

  private
    def room_id
      params.fetch("id")
    end
end