# frozen_string_literal: true

require 'rails_helper'

describe AuthenticationController, type: :controller do
  let(:attr) { { id: 1, username: 'username', email: 'user@email.com', password: 'password' } }

  describe 'POST login' do
    before :each do
      User.create(attr)
      post :login, params: { user: login_attr }
    end

    context 'when user is authenticated correctly' do
      let(:jwt_response) { JsonWebToken::JsonWebTokenHelper.decode(JSON.parse(response.body)['token']) }
      let(:login_attr) { { email: 'user@email.com', password: 'password' } }

      it 'sends json response with jwt' do
        expect(jwt_response[:user][:id]).to eq(1)
      end
    end

    context 'when user is NOT authenticated correctly' do
      let(:error_response) { JSON.parse(response.body)['error'] }
      let(:login_attr) { { email: 'user@email.com', password: 'pass' } }

      it 'sends json response with jwt' do
        expect(error_response).to eq('unauthorized')
      end
    end
  end

  describe 'GET contacts' do
    let(:response_body) { JSON.parse(response.body) }
    let(:token) { JsonWebToken::JsonWebTokenHelper.encode({ user: attr }) }

    context 'when user requests contacts with valid jwt' do
      let(:headers) { { 'Authorization': "Bearer #{token}" } }

      it 'sends json response with jwt' do
        User.create(attr)
        request.headers['Authorization'] = headers[:Authorization]

        get :contacts

        expect(response_body.length).to eq(10)
      end
    end

    context 'when user requests contacts with invalid credentials' do
      let(:attr) { { id: 1, username: 'user', email: 'email.com', password: 'pass' } }
      let(:headers) { { 'Authorization': "Bearer #{token}" } }

      it 'sends json error response with status unauthorized' do
        User.create(attr)
        request.headers['Authorization'] = headers[:Authorization]

        get :contacts

        expect(response_body.symbolize_keys).to have_key(:error)
      end
    end

    context 'when user requests contacts with an invalid jwt' do
      let(:invalid_token) do
        'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJ5c2VybmFtZSIsImVtYWlsIjoidXNlckBlbWFpbC5jb20iJCJwYXNzd29yZCI6InBhc3N3b3JkIiwiZXhwIjoxNTkxODUyNzE0fQ.EKonRDLQ4jtCVJ2rdWdgZnV2QoRD8X8pTGz6bgCCsAU'
      end

      it 'sends json error response with status unauthorized' do
        User.create(attr)
        request.headers['Authorization'] = "Bearer #{invalid_token}"

        get :contacts

        expect(response_body.symbolize_keys).to have_key(:error)
      end
    end
  end
end
