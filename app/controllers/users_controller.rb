# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      token = encode_token('User registered.')
      time = Time.now + 24.hours.to_i

      send_response(token, :created, time)
    else
      send_error(:unprocessable_entity)
    end
  end

  # PUT /users/{username}
  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(user_params)
      token = encode_token('User updated successfully.')
      time = Time.now + 24.hours.to_i

      send_response(token, :accepted, time)
    else
      send_error(:unprocessable_entity)
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :username, :email, :password).to_h.symbolize_keys
  end
end
