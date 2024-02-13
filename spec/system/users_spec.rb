require 'rails_helper'

RSpec.describe 'users', type: :system do
  describe 'user page' do
    let(:user) { create(:user, :confirmed, :with_edited_profile) }
    let(:profile) { user.profile }

    it "has user's profile", :aggregate_failures do
      visit user_path(user)
      expect(page).to have_current_path user_path(user)
      expect(page).to have_selector "img[@alt='#{profile.display_name}のプロフィール画像']"
      expect(page).to have_text profile.display_name
      expect(page).to have_text profile.human_attribute_enum(:prefecture)
      expect(page).to have_text profile.description
      expect(page).to have_link href: 'https://twitter.com/'.concat(profile.x_username)
      expect(page).to have_link href: 'https://instagram.com/'.concat(profile.ig_username)
    end

    it "shows top page with an error message" do
      visit user_path('hogehoge')
      expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.page_not_found')
    end

    context "when user has not signed in" do
      it "doesn't have link to edit user's profile" do
        visit user_path(user)
        expect(page).not_to have_link edit_profile_path(user)
      end
    end

    context "when user has signed in" do
      it "has link to edit user's profile" do
        sign_in user
        visit user_path(user)
        expect(page).to have_link t('users.show.edit_profile'), href: edit_profile_path(user)
        expect(page).to have_link t('users.show.edit_authentication_information'), href: edit_user_registration_path
      end
    end
  end
end
