require 'rails_helper'

RSpec.describe "UsersSession", type: :system do
  describe 'user sign in' do
    let(:user) { create(:user) }
    let!(:attrs) { attributes_for :user }
    before { user.confirm }

    context 'when information is valid' do
      specify 'user can sign in with valid username' do
        visit new_user_session_path

        fill_in 'user[login]', with: attrs[:username]
        fill_in 'user[password]', with: attrs[:password]
        click_button 'commit'
        expect(page).to have_selector 'div.alert-success', text: t('users.sessions.signed_in')
        expect(page).to have_link t('users.sessions.destroy.sign_out'), href: destroy_user_session_path
        expect(page).to have_link t('users.visit_current_user_page'), href: user_path(user)
      end

      specify 'user can sign in with valid email' do
        visit new_user_session_path

        fill_in 'user[login]', with: attrs[:email]
        fill_in 'user[password]', with: attrs[:password]
        click_button 'commit'
        expect(page).to have_selector 'div.alert-success', text: t('users.sessions.signed_in')
      end
    end

    context 'when information is not valid' do
      specify 'user cannot sign in with invalid username' do
        visit new_user_session_path

        fill_in 'user[login]', with: 'invalid_username'
        fill_in 'user[password]', with: attrs[:password]
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: t('users.failure.invalid', authentication_keys: User.human_attribute_name(:login))
      end

      specify 'user cannot sign in with invalid email' do
        visit new_user_session_path

        fill_in 'user[login]', with: 'invalid_email@example.com'
        fill_in 'user[password]', with: attrs[:password]
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: t('users.failure.invalid', authentication_keys: User.human_attribute_name(:login))
      end

      specify 'user cannot sign in with invalid password' do
        visit new_user_session_path

        fill_in 'user[login]', with: attrs[:username]
        fill_in 'user[password]', with: 'invalid_password'
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: t('users.failure.invalid', authentication_keys: User.human_attribute_name(:login))
      end
    end
  end

  describe 'user sign out' do
    before do
      user = create(:user)
      user.confirm
      sign_in user
    end

    specify 'user can sign out successfully' do
      visit root_path
      click_link 'sign-out-link'

      expect(page).to have_selector 'div.alert-success', text: t('users.sessions.signed_out')
    end
  end

  describe 'user session expiration' do
    let!(:user) { create(:user) }
    before { user.confirm }

    context 'when "remember me" is not set' do
      specify 'user session times out in 30 minutes after last access' do
        visit new_user_session_path
        fill_in 'user[login]', with: user.username
        fill_in 'user[password]', with: user.password
        uncheck 'user[remember_me]'
        click_button 'commit'

        expect(page).to have_selector 'div.alert-success', text: t('users.sessions.signed_in')

        travel_to 29.minutes.after
        visit edit_user_registration_path
        expect(page).to have_current_path edit_user_registration_path

        travel_to 1.minute.after
        visit edit_user_registration_path
        expect(page).to have_current_path edit_user_registration_path

        travel_to 30.minutes.after
        visit edit_user_registration_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_selector 'div.alert-warning', text: t('users.failure.timeout')
      end
    end

    context 'when "remember_me" is set' do
      specify 'user is required to sign in again after 2 weeks' do
        visit new_user_session_path
        fill_in 'user[login]', with: user.username
        fill_in 'user[password]', with: user.password
        check 'user[remember_me]'
        click_button 'commit'

        expect(page).to have_selector 'div.alert-success', text: t('users.sessions.signed_in')

        travel_to 2.weeks.after
        visit edit_user_registration_path
        expect(page).to have_current_path edit_user_registration_path

        travel_to 1.day.after
        visit edit_user_registration_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_selector 'div.alert-warning', text: t('users.failure.timeout')
      end
    end
  end
end
