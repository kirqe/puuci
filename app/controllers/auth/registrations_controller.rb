# frozen_string_literal: true

class RegistrationsController < ApplicationController
  get '/signup' do
    redirect to '/' if warden.authenticated?

    slim :'registrations/signup', layout: :auth_layout
  end

  post '/signup' do
    @user = User.new(
      username: params[:user][:username],
      email: params[:user][:email],
      password: params[:user][:password]
    )

    if @user.save
      flash :success, 'You have sucessfully created an account. Please sign in.'
      redirect '/login'
    else
      flash :error, "There're some errors preventing this account from being created: \
                     <br>#{@user.errors.full_messages.join('<br>')}"
      redirect '/signup'
    end
  end
end
