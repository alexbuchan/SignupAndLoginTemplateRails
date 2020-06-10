# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }

  describe 'POST create' do
    before :each do
      post :create, params: { user: attr }
    end

    context 'when user is saved correctly' do
      let(:attr) { { username: 'username', email: 'user@email.com', password: 'password' } }

      it 'sends json response with jwt' do
        expect(response_body).to have_key('token')
      end
    end

    context 'when user is NOT saved correctly' do
      let(:attr) { { username: 'us', email: 'user@email', password: 'pass' } }

      it 'sends json error response' do
        expect(response_body['error']).to eq([
          'Username is too short (minimum is 3 characters)',
          'Email is invalid',
          'Password is too short (minimum is 6 characters)'
        ])
      end
    end
  end

  describe 'PUT update' do
    let(:attr) { { username: 'username', email: 'user@email.com', password: 'password' } }
    let(:user) { User.create(attr) }
    let(:token) { JsonWebToken::JsonWebTokenHelper.encode(new_attr) }
    let(:headers) { { 'Authorization': "Bearer #{token}" } }

    before :each do
      request.headers['Authorization'] = headers[:Authorization]
      put :update, params: { id: user.to_param.to_i, user: new_attr }
    end

    context 'when user is updated correctly' do
      let(:jwt_response) { JsonWebToken::JsonWebTokenHelper.decode(JSON.parse(response.body)['token']) }
      let(:new_attr) do
        { id: user.to_param.to_i, username: 'new username', email: 'new_user@email.com', password: 'password' }
      end

      it 'sends json response with jwt' do
        jwt_response[:user].to_h.symbolize_keys.each do |key, param|
          expect(param).to eq(new_attr[key])
        end
      end
    end

    context 'when user is NOT updated correctly' do
      let(:new_attr) { { id: user.to_param.to_i, username: 'us', email: 'new_user@email', password: 'pass' } }

      it 'sends json error response' do
        expect(response_body['error']).to eq([
          'Username is too short (minimum is 3 characters)',
          'Email is invalid',
          'Password is too short (minimum is 6 characters)'
        ])
      end
    end
  end
end
