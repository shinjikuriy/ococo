require 'rails_helper'

RSpec.describe 'users', type: :system do
  describe 'sign up' do
    it 'signs up with valid information' do
      visit new_user_registration_path

      attrs = attributes_for :user
      fill_in 'user[username]', with: attrs[:username]
      fill_in 'user[email]', with: attrs[:email]
      fill_in 'user[password]', with: attrs[:password]
      fill_in 'user[password_confirmation]', with: attrs[:password]
      click_button 'commit'

      expect(page).to have_text 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    end
  end

  describe 'sign in' do
    let!(:user) { create(:user) }
    before { user.confirm }

    it 'signs in with valid username' do
      visit new_user_session_path

      attrs = attributes_for :user
      fill_in 'user[login]', with: attrs[:username]
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'

      expect(page).to have_text 'Signed in successfully.'
    end

    it 'signs in with valid email' do
      visit new_user_session_path

      attrs = attributes_for :user
      fill_in 'user[login]', with: attrs[:email]
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'

      expect(page).to have_text 'Signed in successfully.'
    end
  end
end
