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

      expect(page).to have_text '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
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
      expect(page).to have_selector 'div.alert-success', text: 'ログインしました。'
    end

    it 'signs in with valid email' do
      visit new_user_session_path

      fill_in 'user[login]', with: attrs[:email]
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'div.alert-success', text: 'ログインしました。'
    end

    it 'cannot sign in with invalid username' do
      visit new_user_session_path

      fill_in 'user[login]', with: 'invalid_username'
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: 'ユーザーIDまたはEメールまたはパスワードが違います。'
    end

    it 'cannot sign in with invalid email' do
      visit new_user_session_path

      fill_in 'user[login]', with: 'invalid_email@example.com'
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: 'ユーザーIDまたはEメールまたはパスワードが違います。'
    end

    it 'cannot sign in with invalid password' do
      visit new_user_session_path

      fill_in 'user[login]', with: attrs[:username]
      fill_in 'user[password]', with: 'invalid_password'
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: 'ユーザーIDまたはEメールまたはパスワードが違います。'
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
      click_link 'sign-out-link'

      expect(page).to have_selector 'div.alert-success', text: 'ログアウトしました。'
    end
  end

  describe 'display user page' do
    let!(:user) { create(:user) }
    before { user.confirm }

    it "has user's profile page" do
      visit user_path(user.id)
      expect(page).to have_current_path user_path(user.id)
      expect(page).to have_text user.profile.display_name
      expect(page).to have_text user.profile.human_attribute_enum(:prefecture)
      expect(page).to have_selector "img[@alt='#{user.profile.display_name}のプロフィール画像']"
    end
  end
end
