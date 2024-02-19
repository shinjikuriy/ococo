require 'rails_helper'

RSpec.describe "Journals", type: :system do
  describe 'CREATE' do
    let!(:user) { create(:user, :confirmed) }
    let!(:pickle) { user.pickles.create(attributes_for(:pickle)) }
    let!(:attrs_journal) { attributes_for(:journal) }
    before { sign_in user }

    specify "pickle's owner can post a journal on the pickle's page", js: true do
      pickle
      visit user_path(user)
      click_link pickle.name
      fill_in 'journal_body', with: attrs_journal[:body]
      expect do
        within '.journal-form' do
          click_button 'commit'
        end
        sleep 0.5
      end.to change { Journal.count }.by 1
      expect(page).to have_selector 'div.alert-success'
      expect(find('#journals')).to have_text attrs_journal[:body]
    end

    specify "user cannot post a journal on other user's pickle" do
      lena = create(:user_lena)
      pickle_lena = lena.pickles.create(attributes_for(:pickle_kabu))

      visit user_path(lena)
      click_link pickle_lena.name
      expect(page).not_to have_selector '.journal-form'
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

    specify "journals are shown on the pickle's page and paginated" do
      visit pickle_path(pickle)
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

    specify 'all journals are shown on index page' do
      lukas = user
      lena = create(:user_lena)
      stefan = create(:user_stefan)
      pickle.journals.clear
      lena.confirm
      stefan.confirm
      pickle_lena = lena.pickles.create(attributes_for(:pickle_kabu))
      pickle_stefan = stefan.pickles.create(attributes_for(:pickle_celery))

      10.times do
        [pickle, pickle_lena, pickle_stefan].each do |p|
          p.journals.create!(body: Faker::Lorem.sentence(word_count: 3))
        end
      end
      journals = Journal.order(created_at: :desc)

      visit journals_path
      journals[0..9].each do |j|
        expect(find('#journals')).to have_text j.body
      end
      expect(page).to have_link '次', href: journals_path(page: 2)
      expect(page).to have_link '最後', href: journals_path(page: 3)
    end
  end

  describe 'DELETE' do
    let!(:user) { create(:user, :confirmed) }
    let!(:pickle) { user.pickles.create(attributes_for(:pickle)) }
    let!(:journal) { pickle.journals.create(attributes_for(:journal)) }
    before { sign_in user }

    specify 'user can delete own journal', js: true do
      visit user_path(user)
      within '#journals' do
        expect do
          page.accept_confirm do
            click_on t('journals.shared.destroy_journal')
          end
          sleep 0.5
        end.to change { Journal.count }.by -1
      end
      expect(page).to have_selector 'div.alert-success', text: t('journals.shared.destroyed_journal')
      expect(find('#journals')).not_to have_text journal.body
    end

    specify "user cannot delete others' journal" do
      lena = create(:user_lena)
      pickle_lena = lena.pickles.create(attributes_for(:pickle_kabu))
      journal_lena = pickle_lena.journals.create(attributes_for(:journal))

      visit user_path(lena)
      expect(find('#journals')).to have_text journal_lena.body
      expect(find('#journals')).not_to have_text t('journals.shared.destroy_journal')
      within '.pickle-section' do
        click_link pickle_lena.name
      end
      expect(find('#journals')).to have_text journal_lena.body
      expect(find('#journals')).not_to have_text t('journals.shared.destroy_journal')
    end
  end
end
