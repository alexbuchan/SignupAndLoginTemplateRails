# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, type: :controller do
  describe 'GET home' do
    it 'returns a welcome html message' do
      get :home
      expect(response.body).to eq('Welcome to the SignupAndLoginTemplate Rails App.')
    end
  end

  describe 'GET not_found', type: :request do
    let(:response_body) { JSON.parse(response.body).symbolize_keys }

    it 'returns an json error message' do
      get '/not_found'
      expect(response_body).to eq({ error: 'Not found' })
    end
  end
end
