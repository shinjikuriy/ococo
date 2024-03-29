require 'rails_helper'

RSpec.describe "UsersRegistration", type: :system do
  describe 'user registration' do
    let!(:attrs) { attributes_for(:user) }

    context 'when information is valid' do
      specify 'new user can successfully sign up' do
        visit new_user_registration_path

        expect {
          fill_in 'user_username', with: attrs[:username]
          fill_in 'user_email', with: attrs[:email]
          fill_in 'user_password', with: attrs[:password]
          fill_in 'user_password_confirmation', with: attrs[:password]
          click_button 'commit'

          expect(page).to have_text t('users.registrations.signed_up_but_unconfirmed')
        }.to change { User.count }.by(1)

        user = User.find_by(username: attrs[:username])
        expect(user).not_to be_confirmed

        # At this point, a confirmation email must be sent properly
        expect(last_email.to).to eq [user.email]

        # the user's features must be unavailable
        visit new_user_session_path
        fill_in 'user_login', with: attrs[:username]
        fill_in 'user_password', with: attrs[:password]
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: t('users.failure.unconfirmed')

        visit last_sent_url
        expect(page).to have_text t('users.confirmations.confirmed')
        expect(user.reload).to be_confirmed
      end
    end

    context 'when information is invalid' do
      before { visit new_user_registration_path }

      specify 'alerts appear for unenterd fields' do
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.blank'))
        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:email).concat(t('errors.messages.blank'))
        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password).concat(t('errors.messages.blank'))
        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password).concat(t('errors.messages.blank'))
      end

      specify 'an alert appears for username that conflicts with pathnames' do
        pathnames = %w[sign_in sign_out password confirmation unlock cancel sign_up edit_credentials pickles]
        pathnames.each do |pathname|
          fill_in 'user_username', with: pathname
          click_button 'commit'
          expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.taken'))
        end
      end
      specify 'alert appears for username less than 3 characters' do
        fill_in 'user_username', with: 'a' * 2
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.too_short', count: 3))
      end

      specify 'alert appears for username over 30 characters' do
        fill_in 'user_username', with: 'a' * 31
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.too_long', count: 30))
      end

      specify 'alert appears for invalid username like "lukas.s"' do
        fill_in 'user_username', with: 'lukas.s'
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.invalid_username_format')
      end

      specify 'alert appears for invalid email like "lukas@sky@walker"' do
        fill_in 'user_email', with: 'lukas@sky@walker'
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.invalid')
      end

      specify 'alert appears for password less than 6 characters' do
        fill_in 'user_password', with: 'a' * 5
        fill_in 'user_password_confirmation', with: 'a' * 5
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password).concat(t('errors.messages.too_short', count: 6))
      end

      context 'when new information is already taken' do
        another_user = User.create(
          username: 'another_user',
          email: 'another_user@example.com',
          password: 'password'
        )

        specify 'alert appears for duplicated username' do
          fill_in 'user_username', with: another_user.username
          fill_in 'user_email', with: attrs[:email]
          fill_in 'user_password', with: attrs[:password]
          fill_in 'user_password_confirmation', with: attrs[:password]
          click_button 'commit'

          expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
        end

        specify 'alert appears for duplicated email' do
          fill_in 'user_username', with: attrs[:username]
          fill_in 'user_email', with: another_user.email
          fill_in 'user_password', with: attrs[:password]
          fill_in 'user_password_confirmation', with: attrs[:password]
          click_button 'commit'

          expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
        end
      end
    end
  end

  describe 'user update' do
    let!(:user) { create(:user, :confirmed) }
    before do
      sign_in user
      visit edit_user_registration_path
    end

    context 'when new information is valid' do
      specify 'user can edit username' do
        fill_in 'user_username', with: 'lukas_new'
        fill_in 'user_email', with: user.email
        fill_in 'user_current_password', with: user.password
        click_button 'commit'

        expect(page).to have_current_path(user_path('lukas_new'))
        expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')
      end

      specify 'user can edit email' do
        fill_in 'user_username', with: user.username
        fill_in 'user_email', with: 'lukas_new@example.com'
        fill_in 'user_current_password', with: user.password
        click_button 'commit'

        expect(page).to have_current_path(user_path(user))
        expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')

        second_last_email = ActionMailer::Base.deliveries[-2]
        expect(second_last_email.to).to eq ['lukas@example.com']
        expect(second_last_email.subject).to eq t('users.mailer.email_changed.subject')

        expect(last_email.to).to eq ['lukas_new@example.com']
        expect(last_email.subject).to eq t('users.mailer.confirmation_instructions.subject')

        visit last_sent_url
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_selector 'div.alert-success', text: t('users.confirmations.confirmed')
      end

      specify 'user can edit password' do
        fill_in 'user_username', with: user.username
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: 'new_password'
        fill_in 'user_password_confirmation', with: 'new_password'
        fill_in 'user_current_password', with: user.password
        click_button 'commit'

        expect(page).to have_current_path(user_path(user))
        expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')

        expect(last_email.to).to eq [user.email]
        expect(last_email.subject).to eq t('users.mailer.password_change.subject')
      end

      context 'when each form is blank' do
        specify 'username will not be changed' do
          fill_in 'user_username', with: ''
          fill_in 'user_email', with: user.email
          fill_in 'user_current_password', with: user.password
          click_button 'commit'

          expect(page).to have_current_path(user_path(user))
          expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')
        end

        specify 'email will not be changed' do
          fill_in 'user_username', with: user.username
          fill_in 'user_email', with: ''
          fill_in 'user_current_password', with: user.password
          click_button 'commit'

          expect(page).to have_current_path(user_path(user))
          expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')
        end

        specify 'password will not be changed' do
          fill_in 'user_username', with: ''
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: ''
          fill_in 'user_password_confirmation', with: ''
          fill_in 'user_current_password', with: user.password
          click_button 'commit'

          expect(page).to have_current_path(user_path(user))
          expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')
        end
      end
    end

    context 'when new information is invalid' do
      specify 'alert appears for username less than 3 characters' do
        fill_in 'user_username', with: 'a' * 2
        fill_in 'user_email', with: user.email
        fill_in 'user_current_password', with: user.password
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.too_short', count: 3))
      end

      specify 'alert appears for username over 30 characters' do
        fill_in 'user_username', with: 'a' * 31
        fill_in 'user_email', with: user.email
        fill_in 'user_current_password', with: user.password
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.too_long', count: 30))
      end

      specify 'alert appears for invalid username like "lukas.s"' do
        fill_in 'user_username', with: 'lukas.s'
        fill_in 'user_email', with: user.email
        fill_in 'user_current_password', with: user.password
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.invalid_username_format')
      end

      specify 'alert appears for invalid email like "lukas@sky@walker"' do
        fill_in 'user_username', with: user.username
        fill_in 'user_email', with: 'lukas@sky@walker'
        fill_in 'user_current_password', with: user.password
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.invalid')
      end

      context 'when new information is already taken' do
        another_user = User.create(
          username: 'another_user',
          email: 'another_user@example.com',
          password: 'password'
        )

        specify 'alert appears for duplicated username' do
          fill_in 'user_username', with: another_user.username
          fill_in 'user_email', with: user.email
          fill_in 'user_current_password', with: user.password
          click_button 'commit'

          expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
        end

        specify 'alert appears for duplicated email' do
          fill_in 'user_username', with: user.username
          fill_in 'user_email', with: another_user.email
          fill_in 'user_current_password', with: user.password
          click_button 'commit'

          expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
        end
      end
    end
  end

  describe 'user cancellation', js: true do
    specify 'user can delete account' do
      user = create(:user, :confirmed)
      sign_in user

      visit user_path(user)
      click_on t('users.show.edit_authentication_information')
      expect(page).to have_current_path(edit_user_registration_path)
      expect do
        page.accept_confirm(t('users.registrations.edit.are_you_sure')) do
          click_button t('users.registrations.edit.cancel_my_account')
        end
        sleep 0.5
      end.to change { User.count }.by(-1)
      expect(page).to have_current_path root_path
      expect(page).to have_selector 'div.alert-success', text: t('users.registrations.destroyed')
    end
  end
end
