require 'rails_helper'

RSpec.describe "Journals", type: :system do
  describe 'CREATE' do
    let(:user) { create(:user, :confirmed) }
    let(:pickle) { user.pickles.create(attributes_for(:pickle)) }
    let!(:attrs_journal) { attributes_for(:journal) }
    before { sign_in user }

    specify "user can post a journal on the pickle's page" do
      visit user_path(user)
      click_link pickle.name
      fill_in 'journal_body', with: attrs_journal[:body]
      expect do
        within '.journal-form' do
          click_button 'commit'
        end
      end.to change { Journal.count }.by 1
    end
  end

  describe 'READ'

  describe 'UPDATE'

  describe 'DELETE'
end
