require 'rails_helper'

RSpec.describe "UsersUnlock", type: :system do
  let!(:user) { create(:user) }
  before { user.confirm }

  describe 'user unlock' do
    xspecify 'user gets locked and can get unlocked' do
      visit new_user_session_path
      4.times do
        fill_in 'user[login]', with: user.username
        fill_in 'user[password]', with: 'hogehoge'
        click_button 'commit'
      end
      expect(page).to have_selector 'div.alert-warning', text: t('users.failure.last_attempt')

      fill_in 'user[login]', with: user.username
      fill_in 'user[password]', with: 'hogehoge'
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: t('users.failure.locked')

      # should check if unlock instruction email has actually been sent

      # visit user_unlock_url(unlock_token: user.reload.unlock_token.html_safe)
      # expect(page).to have_current_path new_user_session_path
      # expect(page).to have_selector 'div.alert-success', text: t('users.unlocks.unlocked')
    end
  end

  describe 'unlock instruction email' do
    context 'when user is locked' do
      specify 'unlock instruction email is resent' do
        visit new_user_session_path
        5.times do
          fill_in 'user[login]', with: user.username
          fill_in 'user[password]', with: 'hogehoge'
          click_button 'commit'
        end

        click_link t('users.shared.links.didn_t_receive_unlock_instructions')
        expect(page).to have_current_path new_user_unlock_path
        fill_in 'user[email]', with: user.email
        click_button 'commit'
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_selector 'div.alert-success', text: t('users.unlocks.send_instructions')
      end
    end

    context 'when user is not locked' do
      specify 'alert appears' do
        visit new_user_unlock_path
        fill_in 'user[email]', with: user.email
        click_button 'commit'

        expect(page).to have_current_path user_unlock_path
        expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:email).concat(t('errors.messages.not_locked'))
      end
    end
  end
end
