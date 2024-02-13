require 'rails_helper'

RSpec.describe "UsersUnlock", type: :system do
  let!(:user) { create(:user, :confirmed) }

  describe 'user unlock' do
    specify 'user gets locked and can get unlocked' do
      visit new_user_session_path
      4.times do
        fill_in 'user_login', with: user.username
        fill_in 'user_password', with: 'hogehoge'
        click_button 'commit'
      end
      expect(page).to have_selector 'div.alert-warning', text: t('users.failure.last_attempt')

      fill_in 'user_login', with: user.username
      fill_in 'user_password', with: 'hogehoge'
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: t('users.failure.locked')

      visit last_sent_url
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_selector 'div.alert-success', text: t('users.unlocks.unlocked')
    end
  end

  context 'when user is locked' do
    specify 'unlock instruction email is resent' do
      visit new_user_session_path
      5.times do
        fill_in 'user_login', with: user.username
        fill_in 'user_password', with: 'hogehoge'
        click_button 'commit'
      end

      click_link t('users.shared.links.didn_t_receive_unlock_instructions')
      expect(page).to have_current_path new_user_unlock_path
      fill_in 'user_email', with: user.email
      click_button 'commit'
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_selector 'div.alert-success', text: t('users.unlocks.send_instructions')
    end
  end

  context 'when user is not locked' do
    specify 'alert appears' do
      visit new_user_unlock_path
      fill_in 'user_email', with: user.email
      click_button 'commit'

      expect(page).to have_current_path user_unlock_path
      expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:email).concat(t('errors.messages.not_locked'))
    end
  end
end
