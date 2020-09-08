
  class SessionsController < ApplicationController
    get "/login" do
      if params[:a] # /login?i=auth_token        
        @user = User.find_by(auth_token: params[:a])
        warden.set_user(@user)
        
        redirect "/settings?a=#{params[:a]}"
      else
        redirect to "/" if warden.authenticated?
        slim :'sessions/login', layout: :auth_layout
      end
    end

    post "/login" do
      env['warden'].authenticate!
      flash :success, "You have successfully logged in as <a href='/u/#{current_user.username}' class='alert-link'>#{current_user.username}</a>"
      
      if session[:return_to].nil? 
        redirect "/projects"
      else        
        redirect session[:return_to]
      end

      
      # user = User.find_by(email: params[:email])
      # if user && user.authenticate(params[:password])      
      #   session[:user_id] = user.id
      #   session.options[:expire_after] = 2592000 unless params[:remember_me].nil? # 30 days
      #   env['warden'].authenticate!

      # flash :success, "You have successfully logged in as <a href='/u/#{user.username}' class='alert-link'>#{user.username}</a>"
      # redirect "/projects"
      # else
      #   flash :error, "Invalid username or password"
      #   redirect "/login"
      # end
    end

    get "/reset" do      
      slim :'sessions/reset', layout: :auth_layout
    end

    post "/reset" do
      user = User.find_by(email: params[:email])
      if user
        user.create_auth_token
        user.save

        send_email_to(user)
        
        flash :success, "Check your email. Use the generated link to update your details."
        redirect "/login"
      else
        flash :error, "Email doesn't exist"
        redirect "/login"
      end
    end

    get "/logout" do
      env['warden'].raw_session.inspect
      env['warden'].logout
      session[:user_id] = nil
      flash :notice, "You have successfully logged out"
      redirect "/login"
    end

    post '/unauthenticated/?' do
      
      # flash[:error] = 
      session[:email] = params[:email]
      session[:return_to] = env['warden.options'][:attempted_path]
      status 401
      flash :error, env["warden"].message unless env["warden"].message.blank?

      redirect "/login"
    end

    private
      def send_email_to(user)
        body = "Hey there! Here's your login link. You can only update your password once using this <a href='http://localhost:9292/login?a=#{user.auth_token}' target='_blank'>link</a>."
        EmailWorker.perform_async(user.email, "restore access", body)
      end
  end
