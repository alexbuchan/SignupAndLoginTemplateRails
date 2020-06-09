# frozen_string_literal: true

module JsonWebToken
  # JsonWebTokenHelper
  class JsonWebTokenHelper
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
    private_constant :SECRET_KEY

    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    end
  end
end
