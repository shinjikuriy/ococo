require 'rails_helper'

RSpec.describe "UsersRegistration", type: :system do
  describe 'user registration' do
    context 'when information is valid' do
      specify 'new user can successfully sign up' do
        attrs = attributes_for :user
        visit new_user_registration_path

        expect {
          fill_in 'user[username]', with: attrs[:username]
          fill_in 'user[email]', with: attrs[:email]
          fill_in 'user[password]', with: attrs[:password]
          fill_in 'user[password_confirmation]', with: attrs[:password]
          click_button 'commit'

          expect(page).to have_text t('users.registrations.signed_up_but_unconfirmed')
        }.to change { User.count }.by(1)

        user = User.find_by(username: attrs[:username])
        expect(user).not_to be_confirmed

        # At this point, a confirmation email must be sent properly
        # Also the user's features must be unavailable

        visit root_url.concat("/confirmation?confirmation_token=#{user.confirmation_token}")
        expect(page).to have_text t('users.confirmations.confirmed')
        expect(user.reload).to be_confirmed
      end
    end

    context 'when information is invalid' do
      let(:attrs) { attributes_for :user }
      before { visit new_user_registration_path }

      specify 'alerts appear for unenterd fields' do
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.blank'))
        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:email).concat(t('errors.messages.blank'))
        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password).concat(t('errors.messages.blank'))
        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password).concat(t('errors.messages.blank'))
      end

      specify 'alert appears for username less then 3 characters' do
        fill_in 'user[username]', with: 'a' * 2
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.too_short', count: 3))
      end

      specify 'alert appears for username over 30 characters' do
        fill_in 'user[username]', with: 'a' * 31
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.too_long', count: 30))
      end

      specify 'alert appears for invalid username like "lukas.s"' do
        fill_in 'user[username]', with: 'lukas.s'
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.invalid_username_format')
      end

      specify 'alert appears for duplicated username' do
        User.create(attrs)

        fill_in 'user[username]', with: attrs[:username]
        fill_in 'user[email]', with: attrs[:email]
        fill_in 'user[password]', with: attrs[:password]
        fill_in 'user[password_confirmation]', with: attrs[:password]
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
      end

      # specify 'alert appears for invalid email like "lukas@skywalker"' do
      #   fill_in 'user[email]', with: 'lukas@skywalker'
      #   click_button 'commit'

      #   expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.invalid')
      # end

      specify 'alert appears for password less than 6 characters' do
        fill_in 'user[password]', with: 'a' * 5
        fill_in 'user[password_confirmation]', with: 'a' * 5
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password).concat(t('errors.messages.too_short', count: 6))
      end
    end
  end

  describe 'user update'

  describe 'user withdrawal'
end
