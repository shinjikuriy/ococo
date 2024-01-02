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

  describe 'user page' do
    let!(:user) { create(:user) }
    let!(:profile) { user.profile }
    before do
      user.confirm
      profile.display_name = 'ルーカス'
      profile.prefecture = 'akita'
      profile.description = 'ドイツ出身です。よろしくお願いします。'
      profile.x_username = 'luke_x'
      profile.ig_username = 'luke_ig'
      user.save!
    end

    it "has user's profile" do
      visit show_user_path(user.id)
      expect(page).to have_current_path show_user_path(user.id)
      expect(page).to have_selector "img[@alt='#{user.profile.display_name}のプロフィール画像']"
      expect(page).to have_text user.profile.display_name
      expect(page).to have_text user.profile.human_attribute_enum(:prefecture)
      expect(page).to have_text profile.description
      expect(page).to have_link href: 'https://twitter.com/'.concat(profile.x_username)
      expect(page).to have_link href: 'https://instagram.com/'.concat(profile.ig_username)
    end

    context "when user has not signed in" do
      it "doesn't have link to edit user's profile" do
        visit show_user_path(user.id)
        expect(page).not_to have_link edit_profile_path(user.id)
      end
    end

    context "when user has signed in" do
      before { user.login }

      it "has link to edit user's profile" do
        visit show_user_path(user.id)
        expect(page).to have_link edit_profile_path(user.id)
      end

      it "can edit display name" do
        visit edit_profile_path(user.id)
        fill_in 'profile[display_name]', with: 'ルーカス🐇'
        click_button 'commit'
        expect(page).to have_current_path show_user_path(user.id)
        expect(page).to have_text 'ルーカス🐇'
      end

      it 'can edit prefecture' do
        visit edit_profile_path(user.id)
        select '秋田', from: 'profile[prefecture]'
        click_button 'commit'
        expect(page).to have_current_path show_user_path(user.id)
        expect(page).to have_text '秋田'
      end

      it 'can edit description' do
        visit edit_profile_path(user.id)
        fill_in 'user[description]', with: 'いぶりがっこが好きです。毎週浅漬をつけています。よろしくお願いします。'
        click_button 'commit'
        expect(page).to have_current_path show_user_path(user.id)
        expect(page).to have_text 'いぶりがっこが好きです。毎週浅漬をつけています。よろしくお願いします。'
      end

      it 'can edit twitter id' do
        visit edit_profile_path(user.id)
        fill_in 'profile[x_username]', with: 'luke_skywalker'
        click_button 'commit'
        expect(page).to have_current_path show_user_path(user.id)
        expect(page).to have_link 'https://twitter.com/luke_skywaker'
      end

      it 'can edit instagram id' do
        visit edit_profile_path(user.id)
        fill_in 'profile[ig_username]', with: 'luke_skywaker_ig'
        click_button 'commit'
        expect(page).to have_current_path show_user_path(user.id)
        expect(page).to have_link 'https://instagram.com/luke_skywaker_ig'
      end

      it 'can edit avatar'
    end
  end
end
