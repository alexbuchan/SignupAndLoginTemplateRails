# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  def home
    render(html: 'Welcome to the SignupAndLoginTemplate Rails App.')
  end

  def not_found
    render(json: { error: 'not_found' })
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken::JsonWebTokenHelper.decode(header)
      @current_user = User.find(@decoded[:id])
    rescue ActiveRecord::RecordNotFound => e
      render(json: { error: e.message }, status: :unauthorized)

    rescue JWT::DecodeError => e
      render(json: { error: e.message }, status: :unauthorized)
    end
  end

  def send_response(token, status, time)
    render(
      json: {
        token: token,
        exp: time.strftime('%m-%d-%Y %H:%M')
      },
      status: status
    )
  end

  def send_error(status)
    render(
      json: {
        error: @user.errors.full_messages
      },
      status: status
    )
  end

  def encode_token(message)
    JsonWebToken::JsonWebTokenHelper.encode({
      user: {
        id: @user.id,
        username: @user.username,
        email: @user.email
      },
      auth: true,
      message: message
    })
  end
end
