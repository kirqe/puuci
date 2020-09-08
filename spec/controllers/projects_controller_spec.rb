require "spec_helper"


# set :environment, :test

RSpec.describe ProjectsController, type: :controller do    
  
    describe "GET /" do
      it "renders index" do
        get '/login'
        # follow_redirect!
     

        expect(last_response).to be_ok
      end
    end
end

