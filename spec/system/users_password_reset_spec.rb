require 'rails_helper'

RSpec.describe "UsersPasswordReset", type: :system do
  let!(:user){ create(:user) }
  before { user.confirm }

  specify 'user can reset password' do
    visit new_user_password_path
    fill_in 'user[email]', with: user.email
    click_button t('users.passwords.new.send_me_reset_password_instructions')
    expect(page).to have_current_path new_user_session_path

    # a reset password instructions email should be sent
    password_reset_mail = ActionMailer::Base.deliveries.last
    mail_body = password_reset_mail.body.encoded
    password_reset_url = URI.extract(mail_body).first

    # the token in the URL must be digested
    visit password_reset_url
    fill_in 'user[password]', with: 'new_password'
    fill_in 'user[password_confirmation]', with: 'new_password'
    click_button 'commit'
    expect(page).to have_current_path new_user_session_path
    expect(page).to have_selector 'div.alert-success', text: t('users.passwords.updated')
  end

  context 'when email does not exist' do
    specify 'an alert appears' do
      visit new_user_password_path
      fill_in 'user[email]', with: 'not_exist@example.com'
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:email).concat(t('errors.messages.not_found'))
    end
  end

  context 'when new password is invalid' do
    before do
      visit new_user_password_path
      fill_in 'user[email]', with: user.email
      click_button t('users.passwords.new.send_me_reset_password_instructions')
      expect(page).to have_current_path new_user_session_path
      password_reset_mail = ActionMailer::Base.deliveries.last
      mail_body = password_reset_mail.body.encoded
      password_reset_url = URI.extract(mail_body).first
      visit password_reset_url
    end

    specify 'alert appears for unenterd field' do
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password).concat(t('errors.messages.blank'))
    end

    specify 'alert appears for password less than 6 characters' do
      fill_in 'user[password]', with: 'a' * 5
      fill_in 'user[password_confirmation]', with: 'a' * 5
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password).concat(t('errors.messages.too_short', count: 6))
    end

    specify 'alert appears for password_confirmation does not match' do
      fill_in 'user[password]', with: 'new_password'
      fill_in 'user[password_confirmation]', with: 'hogehoge'
      click_button 'commit'
      expect(page).to have_selector 'div.alert-warning', text: User.human_attribute_name(:password_confirmation).concat(t('errors.messages.confirmation', attribute: User.human_attribute_name(:password)))
    end
  end

  context 'when the token is expired' do
    xspecify 'user cannot access the page' do
      visit new_user_password_path
      fill_in 'user[email]', with: user.email
      click_button t('users.passwords.new.send_me_reset_password_instructions')
      expect(page).to have_current_path new_user_session_path

      password_reset_mail = ActionMailer::Base.deliveries.last
      mail_body = password_reset_mail.body.encoded
      password_reset_url = URI.extract(mail_body).first

      travel 2.hours + 1.minute
      visit password_reset_url
      expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.expired')
    end
  end
end
