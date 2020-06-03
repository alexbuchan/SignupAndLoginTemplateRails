# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  # GET /users
  def index
    @users = User.all
    render(json: @users, status: :ok)
  end

  # GET /users/{username}
  def show
    render(json: @user, status: :ok)
  end

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

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end
end
