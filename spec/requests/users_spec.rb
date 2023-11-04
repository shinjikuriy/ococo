require 'rails_helper'

RSpec.describe 'users', type: :request do
  describe 'GET /users/sign_up' do
    it 'should respond http success' do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end
end
