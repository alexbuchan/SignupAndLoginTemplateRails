require 'rest-client'

class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = token = JsonWebToken::JsonWebTokenHelper.encode({
        user: {
          user_id: @user.id,
          username: @user.username,
          email: @user.email
        },
        auth: true,
        message: 'User registered'
      })

      time = Time.now + 24.hours.to_i
      render json: { 
        token: token, 
        exp: time.strftime("%m-%d-%Y %H:%M"),
      }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # GET /auth/contacts
  def contacts
    response = RestClient.get('https://jsonplaceholder.typicode.com/users')
    body = JSON.parse(response.body)
    render json: body, status: :ok
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
