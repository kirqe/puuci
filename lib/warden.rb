Warden::Manager.before_failure do |env, _opts|
    # Because authentication failure can happen on any request but
    # we handle it only under "post '/auth/unauthenticated'", we need
    # to change request to POST
    env['REQUEST_METHOD'] = 'POST'
    # And we need to do the following to work with Rack::MethodOverride
    # using `String.new("")` creates an unfrozen object, allowing this project
    # to work with the frozen_string_literal
    env.each do |key, _value|
      env[key]['_method'] = String.new('post') if key == 'rack.request.form_hash'
    end
  end

Warden::Strategies.add(:password) do
  def valid?
    params['email'] && params['password']
  end

  def authenticate!
    user = User.find_by(email: params['email'])

    if user.nil?
      fail!('The username you entered does not exist.')
      # throw(:warden, message: 'The username you entered does not exist.')
    elsif user.authenticate(params['password'])
       
      success!(user)
    else
      fail!('Wrong username and password combination')
    end         
  end
end   