require 'rails_helper'

RSpec.describe 'users', type: :request do
  describe 'GET /users/sign_up' do
    it 'should respond http success' do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /users/sign_in' do
    it 'should respond http success' do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /users/password/new' do
    it 'should respond http success' do
      get new_user_password_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /users/confirmation/new' do
    it 'should respond http success' do
      get new_user_confirmation_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /users/unlock/new' do
    it 'should respond http success' do
      get new_user_unlock_path
      expect(response).to have_http_status(:success)
    end
  end
end
