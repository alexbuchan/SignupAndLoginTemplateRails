class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      token = encodeToken('User registered.')
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
      token = encodeToken('User updated successfully.')
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

  def send_response(token, status, time)
    render json: {
      token: token,
      exp: time.strftime("%m-%d-%Y %H:%M"),
    }, status: status
  end

  def send_error(status)
    render(
      json: {
        error: @user.errors.full_messages
      },
      status: status
    )
  end

  def encodeToken(message)
    JsonWebToken::JsonWebTokenHelper.encode({
      user: {
        user_id: @user.id,
        username: @user.username,
        email: @user.email
      },
      auth: true,
      message: message
    })
  end
end
