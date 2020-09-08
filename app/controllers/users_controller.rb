class UsersController < ApplicationController
  get '/u/:username', :auth => ["user", "admin"] do
    @user = User.includes(:issues, :comments, :projects).find_by(username: params[:username])
    
    slim :'users/show'
  end

  get '/settings', :auth => ["user", "admin"] do
    @user = current_user
   
    slim :'users/edit'
  end

  post '/settings', :auth => ["user", "admin"] do
    @user = current_user
    @user.about = params[:user][:about]

    np = params[:user][:new_password]
    npc = params[:user][:password_confirmation]
    op = params[:user][:old_password]

    if params[:a] && params[:a] == @user.auth_token
      # @user.username = params[:user][:username]
      @user.password = np
    else
      unless [np, npc, op].all?(&:empty?)
        if @user.authenticate(op) && (np == npc)
          @user.password = np
        else
          flash :error, "Either old password or combination of new password and password confirmation is incorrect. <br> If you don't want to change password, leave all password fields blank"
          redirect to "/settings"
        end      
      end
    end

    if @user.save
      flash :success, "Updated successfully"
      redirect "/u/#{@user.username}"
    else
      flash :error, "Something went wrong: #{@user.errors.full_messages.join(", ")}"
      redirect "/settings?a=#{params[:a]}"
    end

    slim :'users/edit'
  end


  get '/u/:username/issues', :auth => ["user", "admin"] do
    @user = User.find_by(username: params[:username])
    @issues = @user.issues.not_draft.paginate(page: params[:page], per_page: 30)

    slim :'issues/index'
  end
  
  get '/u/:username/projects', :auth => ["user", "admin"] do
    @user = User.find_by(username: params[:username])
    @projects = @user.projects.not_draft.paginate(page: params[:page], per_page: 30)

    slim :'projects/index'
  end
end