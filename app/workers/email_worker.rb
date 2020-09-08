class EmailWorker
  include Sidekiq::Worker

  def perform(to, subject, body)
    Pony.mail({
      :to => to,
      :via => :smtp,
      :via_options => {
        :address        => '127.0.0.1',
        :port           => '1025',
        :user_name      => 'user',
        :password       => 'password',
        :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
      },
      :subject => subject, 
      :body => body
    })    
  end
end