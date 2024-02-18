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
  end
end
