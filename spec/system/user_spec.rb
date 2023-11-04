require 'rails_helper'

RSpec.describe 'users', type: :system do
  describe 'GET /users/sign_up' do
    it 'ユーザー登録画面にフィールドが含まれていること' do
      visit new_user_registration_path
      expect(page).to have_field('user_username')
      expect(page).to have_field('user_email')
      expect(page).to have_field('user_password')
      expect(page).to have_field('user_password_confirmation')
    end
  end
end
