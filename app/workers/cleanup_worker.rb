class CleanupWorker
  include Sidekiq::Worker


  def perform(args)
    p "------"

    p "-----"
  end
end