# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true
  validates :username, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
