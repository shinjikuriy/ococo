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
        expect(last_email.to).to eq [user.email]

        # the user's features must be unavailable
        visit new_user_session_path
        fill_in 'user[login]', with: attrs[:username]
        fill_in 'user[password]', with: attrs[:password]
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: t('users.failure.unconfirmed')

        visit last_sent_url
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

      specify 'alert appears for username less than 3 characters' do
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

      specify 'alert appears for invalid email like "lukas@sky@walker"' do
        fill_in 'user[email]', with: 'lukas@sky@walker'
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.invalid')
      end

      specify 'alert appears for password less than 6 characters' do
        fill_in 'user[password]', with: 'a' * 5
        fill_in 'user[password_confirmation]', with: 'a' * 5
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
          User.create(attrs)

          fill_in 'user[username]', with: another_user.username
          fill_in 'user[email]', with: attrs[:email]
          fill_in 'user[password]', with: attrs[:password]
          fill_in 'user[password_confirmation]', with: attrs[:password]
          click_button 'commit'

          expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
        end

        specify 'alert appears for duplicated email' do
          User.create(attrs)

          fill_in 'user[username]', with: attrs[:username]
          fill_in 'user[email]', with: another_user.email
          fill_in 'user[password]', with: attrs[:password]
          fill_in 'user[password_confirmation]', with: attrs[:password]
          click_button 'commit'

          expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
        end
      end
    end
  end

  describe 'user update' do
    let!(:user) { create(:user) }
    before do
      user.confirm
      sign_in user
      visit edit_user_registration_path
    end

    context 'when new information is valid' do
      specify 'user can edit username' do
        fill_in 'user[username]', with: 'lukas_new'
        fill_in 'user[email]', with: user.email
        fill_in 'user[current_password]', with: user.password
        click_button 'commit'

        expect(page).to have_current_path(user_path('lukas_new'))
        expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')
      end

      specify 'user can edit email' do
        fill_in 'user[username]', with: user.username
        fill_in 'user[email]', with: 'lukas_new@example.com'
        fill_in 'user[current_password]', with: user.password
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
        fill_in 'user[username]', with: user.username
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: 'new_password'
        fill_in 'user[password_confirmation]', with: 'new_password'
        fill_in 'user[current_password]', with: user.password
        click_button 'commit'

        expect(page).to have_current_path(user_path(user))
        expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')

        expect(last_email.to).to eq [user.email]
        expect(last_email.subject).to eq t('users.mailer.password_change.subject')
      end

      context 'when each form is blank' do
        specify 'username will not be changed' do
          fill_in 'user[username]', with: ''
          fill_in 'user[email]', with: user.email
          fill_in 'user[current_password]', with: user.password
          click_button 'commit'

          expect(page).to have_current_path(user_path(user))
          expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')
        end

        specify 'email will not be changed' do
          fill_in 'user[username]', with: user.username
          fill_in 'user[email]', with: ''
          fill_in 'user[current_password]', with: user.password
          click_button 'commit'

          expect(page).to have_current_path(user_path(user))
          expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')
        end

        specify 'password will not be changed' do
          fill_in 'user[username]', with: ''
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: ''
          fill_in 'user[password_confirmation]', with: ''
          fill_in 'user[current_password]', with: user.password
          click_button 'commit'

          expect(page).to have_current_path(user_path(user))
          expect(page).to have_selector 'div.alert-success', text: t('users.registrations.updated')
        end
      end
    end

    # Basically the same tests as 'user registration > when information is invalid'
    # must be carried out here
    context 'when new information is invalid' do
      specify 'alert appears for username less than 3 characters' do
        fill_in 'user[username]', with: 'a' * 2
        fill_in 'user[email]', with: user.email
        fill_in 'user[current_password]', with: user.password
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.too_short', count: 3))
      end

      specify 'alert appears for username over 30 characters' do
        fill_in 'user[username]', with: 'a' * 31
        fill_in 'user[email]', with: user.email
        fill_in 'user[current_password]', with: user.password
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:username).concat(t('errors.messages.too_long', count: 30))
      end

      specify 'alert appears for invalid username like "lukas.s"' do
        fill_in 'user[username]', with: 'lukas.s'
        fill_in 'user[email]', with: user.email
        fill_in 'user[current_password]', with: user.password
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.invalid_username_format')
      end

      specify 'alert appears for invalid email like "lukas@sky@walker"' do
        fill_in 'user[username]', with: user.username
        fill_in 'user[email]', with: 'lukas@sky@walker'
        fill_in 'user[current_password]', with: user.password
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
          fill_in 'user[username]', with: another_user.username
          fill_in 'user[email]', with: user.email
          fill_in 'user[current_password]', with: user.password
          click_button 'commit'

          expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
        end

        specify 'alert appears for duplicated email' do
          fill_in 'user[username]', with: user.username
          fill_in 'user[email]', with: another_user.email
          fill_in 'user[current_password]', with: user.password
          click_button 'commit'

          expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.taken')
        end
      end
    end
  end

  describe 'user cancellation', js: true do
    xspecify 'user can delete account' do
      user = create(:user)
      user.confirm
      sign_in user

      expect {
        visit user_path(user)
        click_on t('users.show.edit_authentication_information')
        expect(page).to have_current_path(edit_user_registration_path)
        # method 'accept_confirm' is not working
        # check the version of selenium_driver
        page.accept_confirm do
          click_on t('users.registrations.edit.cancel_my_account')
        end
        page.driver.browser.switch_to.alert.accept
      }.to change { User.count }.by(-1)
    end
  end
end
