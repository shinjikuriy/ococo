require 'rails_helper'

RSpec.describe 'users', type: :system do
  describe 'sign in' do
    let(:user) { create(:user) }
    let!(:attrs) { attributes_for :user }
    before { user.confirm }

    it 'signs in with valid username' do
      visit new_user_session_path

      fill_in 'user[login]', with: attrs[:username]
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'div.alert-success', text: t('users.sessions.signed_in')
      expect(page).to have_link t('users.sessions.destroy.sign_out'), href: destroy_user_session_path
      expect(page).to have_link t('users.visit_current_user_page'), href: show_user_path(user.id)
    end

    it 'signs in with valid email' do
      visit new_user_session_path

      fill_in 'user[login]', with: attrs[:email]
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'div.alert-success', text: t('users.sessions.signed_in')
    end

    it 'cannot sign in with invalid username' do
      visit new_user_session_path

      fill_in 'user[login]', with: 'invalid_username'
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: t('users.failure.invalid', authentication_keys: User.human_attribute_name(:login))
    end

    it 'cannot sign in with invalid email' do
      visit new_user_session_path

      fill_in 'user[login]', with: 'invalid_email@example.com'
      fill_in 'user[password]', with: attrs[:password]
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: t('users.failure.invalid', authentication_keys: User.human_attribute_name(:login))
    end

    it 'cannot sign in with invalid password' do
      visit new_user_session_path

      fill_in 'user[login]', with: attrs[:username]
      fill_in 'user[password]', with: 'invalid_password'
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: t('users.failure.invalid', authentication_keys: User.human_attribute_name(:login))
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

      expect(page).to have_selector 'div.alert-success', text: t('users.sessions.signed_out')
    end
  end

  describe 'user page' do
    let!(:user) { create(:user) }
    let!(:profile) { user.profile }
    before do
      user.confirm
      profile.display_name = 'ルーカス'
      profile.prefecture = 'kanagawa'
      profile.description = 'ドイツ出身です。よろしくお願いします。'
      profile.x_username = 'luke_x'
      profile.ig_username = 'luke_ig'
      user.save!
    end

    it "has user's profile", :aggregate_failures do
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
      it "has link to edit user's profile" do
        sign_in user
        visit show_user_path(user.id)
        expect(page).to have_link t('users.show.edit_profile'), href: edit_profile_path(user.id)
        expect(page).to have_link t('users.show.edit_authentication_information'), href: edit_user_registration_path
      end
    end
  end
end
