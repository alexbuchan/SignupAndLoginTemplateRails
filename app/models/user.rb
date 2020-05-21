class User < ActiveRecord::Base
  validates_presence_of :username, :email, :password
  validates_length_of :username, :minimum => 3
  validates_length_of :password, :minimum => 6
end