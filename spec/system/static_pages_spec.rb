require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "home" do
    let(:user) { create(:user, :confirmed) }
    let(:pickle) { user.pickles.create(attributes_for(:pickle)) }
    before do
      10.times do
        pickle.journals.create(attributes_for(:journal_sequence))
      end
    end

    context "when user is not signed in" do
      specify "navbar has links to sign in and registration" do
        visit root_url
        expect(find('.navbar')).to have_link t('users.shared.links.sign_in')
        expect(find('.navbar')).to have_link t('users.shared.links.sign_up')
      end

      specify "registration banner is shown" do
        visit root_url
        expect(page).to have_selector '.col-registration-banner-pane'
        expect(page).to have_text t('static_pages.home.description')
        expect(page).to have_text t('static_pages.home.registration')
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      specify "navbar has links to user page and sign out" do
        visit root_url
        expect(find('.navbar')).to have_link t('users.visit_current_user_page')
        expect(find('.navbar')).to have_link t('users.sessions.destroy.sign_out')
      end

      specify "registration banner is not shown" do
        visit root_url
        expect(page).not_to have_selector '.col-registration-banner-pane'
        expect(page).not_to have_text t('static_pages.home.description')
        expect(page).not_to have_text t('static_pages.home.registration')
      end
    end

  end
end
