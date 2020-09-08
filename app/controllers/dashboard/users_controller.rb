module Dashboard
  class UsersController < Dashboard::DashboardController
    get '/dashboard/users', :auth => ["admin"] do
      @users = User.all.paginate(page: params[:page], per_page: 30)

      slim :"dashboard/users/index"
    end

    get "/dashboard/users/:user_id/edit", :auth => ["admin"] do
      @user = User.find(params[:user_id])
      
      slim :"dashboard/users/edit"
    end

    post "/dashboard/users/:user_id", :auth => ["admin"] do
      @user = User.find(params[:user_id])
      
      @user.username = params[:username]
      @user.email = params[:email]
      @user.role = params[:role].to_i
      @user.password = params[:password]

      if @user.save 
        flash :success, "You have successfully updated the user"
        redirect back
      else
        flash :error, "Something went wrong: #{@user.errors.full_messages.join(", ")}"
        redirect back
      end
    end


    post '/dashboard/users', :auth => ["admin"] do 

      @user = User.new

      if params[:username].empty?
        un = params[:email].split("@")[0]
        @user.username = "#{un}_#{SecureRandom.hex[0..5]}"
      else
        @user.username = params[:username]
      end
      
      @user.email = params[:email]
      
      @user.password = SecureRandom.hex[0..19]


      
      if @user.save 
        send_email_to(@user, params[:text])

        flash :success, "You have successfully invited a new user"
        redirect back
      else
        flash :error, "Something went wrong: #{@user.errors.full_messages.join(", ")}"
        redirect back
      end

      
    end     

    delete '/dashboard/users/:id', :auth => ["admin"] do |id|    
      @user = User.find(params[:id])
      @user.destroy

      flash :success, "You have successfully deleted the user"
      redirect back
    end

    private
      def send_email_to(user, custom_text)
        body = "Hey there! Here's your login link. 
          You can only update your password once using this <a href='http://localhost:9292/login?a=#{user.auth_token}' target='_blank'>link</a>.
          --
          #{custom_text}"
        EmailWorker.perform_async(user.email, "invitation", body)        
      end    
  end
end

