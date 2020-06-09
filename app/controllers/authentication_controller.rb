# frozen_string_literal: true

require('rest-client')

# AuthenticationController. All routes for now which need authentication will pass through here.
class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(login_params[:email])
    if @user&.authenticate(login_params[:password])
      token = encode_token('User logged in.')
      time = Time.now + 24.hours.to_i
      send_response(token, :ok, time)
    else
      render(json: { error: 'unauthorized' }, status: :unauthorized)
    end
  end

  # GET /auth/contacts
  def contacts
    response = RestClient.get('https://jsonplaceholder.typicode.com/users')
    body = JSON.parse(response.body)
    render(json: body, status: :ok)
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
