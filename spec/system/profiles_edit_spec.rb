require 'rails_helper'

RSpec.describe "ProfilesEdit", type: :system do
  describe 'profile update' do
    let(:user) { create(:user, :confirmed, :with_edited_profile) }
    let(:profile) { user.profile }
    before do
      sign_in user
      visit edit_profile_path
    end

    context 'when information is valid' do
      specify 'user can edit display_name' do
        fill_in 'profile[display_name]', with: 'ルーカス🐇'
        click_button 'commit'
        expect(page).to have_current_path user_path(user)
        expect(page).to have_text 'ルーカス🐇'
      end

      specify 'user can edit prefecture' do
        select '秋田', from: 'profile[prefecture]'
        click_button 'commit'
        expect(page).to have_current_path user_path(user)
        expect(page).to have_text '秋田'
      end

      specify 'user can edit description' do
        fill_in 'profile[description]', with: 'いぶりがっこが好きです。毎週浅漬をつけています。よろしくお願いします。'
        click_button 'commit'
        expect(page).to have_current_path user_path(user)
        expect(page).to have_text 'いぶりがっこが好きです。毎週浅漬をつけています。よろしくお願いします。'
      end

      specify 'user can edit twitter id' do
        fill_in 'profile[x_username]', with: 'luke_skywalker'
        click_button 'commit'
        expect(page).to have_current_path user_path(user)
        expect(page).to have_link href: 'https://twitter.com/luke_skywalker'
      end

      specify 'user can edit instagram id' do
        fill_in 'profile[ig_username]', with: 'luke_skywaker_ig'
        click_button 'commit'
        expect(page).to have_current_path user_path(user)
        expect(page).to have_link href: 'https://instagram.com/luke_skywaker_ig'
      end

      specify 'user can edit avatar' do
        attach_file 'profile[avatar]', "#{Rails.root}/spec/fixtures/avatar_cat.png"
        click_button 'commit'
        expect(page).to have_current_path user_path(user)
        expect(page).to have_selector("img[src$='avatar_cat.png']")
      end
    end

    context 'when information is invalid' do
      specify 'an alert appears when display_name is empty' do
        fill_in 'profile_display_name', with: ''
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Profile.human_attribute_name(:display_name).concat(t('errors.messages.empty'))
      end

      specify 'an alert appears when display_name is more than 30 characters' do
        fill_in 'profile_display_name', with: 'a' * 31
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Profile.human_attribute_name(:display_name).concat(t('errors.messages.too_long', count: 30))
      end

      specify 'an alert appears when description is more than 160 characters' do
        fill_in 'profile_description', with: 'a' * 161
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Profile.human_attribute_name(:description).concat(t('errors.messages.too_long', count: 160))
      end

      specify 'an alert appears when x_username contains invalid characters' do
        fill_in 'profile_x_username', with: 'luke.x'
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Profile.human_attribute_name(:x_username).concat(t('errors.messages.invalid_username_format'))
      end

      specify 'an alert appears when ig_username contains invalid characters' do
        fill_in 'profile_ig_username', with: 'luke_ig!'
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Profile.human_attribute_name(:ig_username).concat(t('errors.messages.invalid_ig_username_format'))
      end

      specify 'an alert appears when avatar file is not an image' do
        attach_file 'profile_avatar', "#{Rails.root}/spec/fixtures/joyo.tsv"
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Profile.human_attribute_name(:avatar).concat(t('errors.messages.invalid_content_type'))
      end

      specify 'an alert appears when avatar file is more than 2MB' do
        attach_file 'profile_avatar', "#{Rails.root}/spec/fixtures/too_large_file.jpg"
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Profile.human_attribute_name(:avatar).concat(t('errors.messages.file_size_is_too_large'))
      end
    end
  end
end
