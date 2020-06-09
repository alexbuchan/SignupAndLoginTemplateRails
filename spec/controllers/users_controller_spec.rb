# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :controller do
  describe 'POST create' do
    context 'when user is saved correctly' do
      let(:jwt_response) { JsonWebToken::JsonWebTokenHelper.decode(JSON.parse(response.body)['token']) }
      let(:attr) { { username: 'username', email: 'user@email.com', password: 'password' } }

      it 'sends json response with jwt' do
        post :create, params: { user: attr }
        expect(jwt_response[:user][:id]).to eq(1)
      end
    end

    context 'when user is NOT saved correctly' do
      let(:error_response) { JSON.parse(response.body) }
      let(:attr) { { username: 'us', email: 'user@email', password: 'pass' } }

      it 'sends json error response' do
        post :create, params: { user: attr }
        expect(error_response['error']).to eq([
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

    context 'when user is updated correctly' do
      let(:jwt_response) { JsonWebToken::JsonWebTokenHelper.decode(JSON.parse(response.body)['token']) }
      let(:new_attr) { { id: 2, username: 'new username', email: 'new_user@email.com', password: 'password' } }
      let(:token) { JsonWebToken::JsonWebTokenHelper.encode(new_attr) }
      let(:headers) { { 'Authorization': "Bearer #{token}" } }

      it 'sends json response with jwt' do
        request.headers['Authorization'] = headers[:Authorization]
        put :update, params: { id: user.to_param.to_i, user: new_attr }

        user.reload
        jwt_response[:user].to_h.symbolize_keys.each do |key, param|
          expect(param).to eq(new_attr[key])
        end
      end
    end

    context 'when user is NOT updated correctly' do
      let(:error_response) { JSON.parse(response.body) }
      let(:new_attr) { { id: 3, username: 'us', email: 'new_user@email', password: 'pass' } }
      let(:token) { JsonWebToken::JsonWebTokenHelper.encode(new_attr) }
      let(:headers) { { 'Authorization': "Bearer #{token}" } }

      it 'sends json error response' do
        request.headers['Authorization'] = headers[:Authorization]
        put :update, params: { id: user.to_param.to_i, user: new_attr }

        expect(error_response['error']).to eq([
          'Username is too short (minimum is 3 characters)',
          'Email is invalid',
          'Password is too short (minimum is 6 characters)'
        ])
      end
    end
  end
end
