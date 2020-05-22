class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  validates_length_of :username, :minimum => 3
  validates_length_of :password, :minimum => 6
end
