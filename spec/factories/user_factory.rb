FactoryBot.define do
  factory :user do
    username { 'Username' }
    email  { 'user@email.com' }
    password { 'password' }
  end
end