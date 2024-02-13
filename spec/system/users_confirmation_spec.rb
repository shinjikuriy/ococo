require 'rails_helper'

RSpec.describe "UsersConfirmation", type: :system do
  describe 'user confirmation' do
    before { visit new_user_confirmation_path }

    context 'when user is registered but not confirmed' do
      specify 'user can confirm account' do
        user = create(:user)

        fill_in 'user_email', with: user.email
        click_button 'commit'
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_selector 'div.alert-success', text: t('users.confirmations.send_instructions')

        expect(last_email.to).to eq [user.email]

        visit last_sent_url
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_selector 'div.alert-success', text: t('users.confirmations.confirmed')
      end

      context 'when email is invalid' do
        specify 'an alert appears' do
          fill_in 'user_email', with: 'hogehoge@example.com'
          click_button 'commit'
          expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:email).concat(t('errors.messages.not_found'))
        end
      end
    end
  end
end
