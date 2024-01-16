require 'rails_helper'

RSpec.describe "UsersConfirmation", type: :system do
  describe 'user confirmation' do
    context 'when user is registered but not confirmed' do
      let!(:user){ create(:user) }
      before { visit new_user_confirmation_path }

      specify 'user can confirm account' do
        fill_in 'user[email]', with: user.email
        click_button 'commit'
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_selector 'div.alert-success', text: t('users.confirmations.send_instructions')

        # a confirmation e-mail should be sent

        visit last_sent_url
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_selector 'div.alert-success', text: t('users.confirmations.confirmed')
      end

      context 'when email is invalid' do
        specify 'an alert appears' do
          fill_in 'user[email]', with: 'hogehoge@example.com'
          click_button 'commit'
          expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:email).concat(t('errors.messages.not_found'))
        end
      end
    end
  end
end
