# frozen_string_literal: true

class CleanupWorker
  include Sidekiq::Worker

  def perform(_args)
    p '------'

    p '-----'
  end
end
