require 'rails_helper'

RSpec.describe "UsersRegistration", type: :system do
  describe 'user registration' do
    context 'when information is valid' do
      specify 'new user can successfully sign up' do
        visit new_user_registration_path

        attrs = attributes_for :user

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

        visit root_url.concat("/users/confirmation?confirmation_token=#{user.confirmation_token}")
        expect(page).to have_text t('users.confirmations.confirmed')
        expect(user.reload).to be_confirmed
      end
    end
  end
end
