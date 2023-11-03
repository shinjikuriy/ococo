require 'rails_helper'

RSpec.describe 'users', type: :system do
  describe 'GET /users/sign_up' do
    it 'ユーザー登録画面にusernameフィールドが含まれていること' do
      visit new_user_registration_path
      expect(page).to have_field('user_username')
    end
  end
end
