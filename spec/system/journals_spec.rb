require 'rails_helper'

RSpec.describe "Journals", type: :system do
  xdescribe 'CREATE' do
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

  describe 'READ' do
    let(:user) { create(:user, :confirmed) }
    let(:pickle) { user.pickles.create(attributes_for(:pickle)) }
    before do
      20.times do
        pickle.journals.create!(attributes_for(:journal_sequence))
      end
    end

    specify 'pickle page shows all its journals' do
      visit pickle_path(pickle)
      journal_section = find('.journal-section')
      pickle.journals.each do |journal|
        expect(journal_section).to have_text journal.body
      end
    end

    specify "user's journals are shown on the user's page and paginated" do
      visit user_path(user)

      journal_section = find('.journal-section')
      pickle.journals.each_with_index do |journal, i|
        if i < 10
          expect(journal_section).to have_text journal.body
        else
          expect(journal_section).not_to have_text journal.body
        end
      end
      within('.journal-section') do
        click_link '次 ›'
      end
      pickle.journals.each_with_index do |journal, i|
        if i < 10
          expect(journal_section).not_to have_text journal.body
        else
          expect(journal_section).to have_text journal.body
        end
      end
    end
  end

  describe 'UPDATE'

  describe 'DELETE'
end
