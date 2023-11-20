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
    before { create(:user).confirm }
    let!(:attrs) { attributes_for :user }

    it 'signs in with valid username' do
      visit new_user_session_path

      fill_in 'user[login]', with: attrs[:username]
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'

      expect(page).to have_selector 'p.notice', text: 'Signed in successfully.'
    end

    it 'signs in with valid email' do
      visit new_user_session_path

      fill_in 'user[login]', with: attrs[:email]
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'

      expect(page).to have_selector 'p.notice', text: 'Signed in successfully.'
    end

    it 'cannot sign in with invalid username' do
      visit new_user_session_path

      fill_in 'user[login]', with: 'invalid_username'
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'p.alert', text: 'Invalid Login or password.'
    end

    it 'cannot sign in with invalid email' do
      visit new_user_session_path

      fill_in 'user[login]', with: 'invalid_email@example.com'
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'p.alert', text: 'Invalid Login or password.'
    end

    it 'cannot sign in with invalid password' do
      visit new_user_session_path

      fill_in 'user[login]', with: attrs[:username]
      fill_in 'user[password]', with: 'invalid_password'
      click_button 'commit'
      expect(page).to have_selector 'p.alert', text: 'Invalid Login or password.'
    end
  end

  describe 'sign out' do
    before do
      user = create(:user)
      user.confirm
      sign_in user
    end

    it 'signs out successfully' do
      visit root_path
      click_link 'sign out'

      expect(page).to have_selector 'p.notice', text: 'Signed out successfully.'
    end
  end
end
