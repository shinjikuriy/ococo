require 'rails_helper'

RSpec.describe "Journals", type: :system do
  describe 'CREATE' do
    let!(:user) { create(:user, :confirmed) }
    let!(:pickle) { user.pickles.create(attributes_for(:pickle)) }
    let!(:attrs_journal) { attributes_for(:journal) }

    context 'when user is not signed in' do
      specify 'journal form is not shown on user page' do
        visit user_path(user)
        journal_section = find('.journal-section')
        expect(journal_section).not_to have_selector 'form'
      end

      specify 'journal form is not shown on pickle page' do
        visit pickle_path(pickle)
        journal_section = find('.journal-section')
        expect(journal_section).not_to have_selector 'form'
      end
    end

    context 'when user is signed in' do
      let!(:lena) { create(:user_lena) }
      let!(:pickle_lena) { lena.pickles.create(attributes_for(:pickle_kabu)) }
      before do
        10.times do
          pickle_lena.journals.create(attributes_for(:journal_lorem))
        end

        sign_in user
      end

      specify "user can create a journal on their own user page", js: true do
        visit user_path(user)
        within '.journal-form' do
          select pickle.name, from: 'journal_pickle_id'
          fill_in 'journal_body', with: attrs_journal[:body]
          expect do
            click_button 'commit'
            sleep 0.5
          end.to change { Journal.count }.by 1
        end
        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.created_journal')

        journal = find "#journal_#{Journal.last.id}"
        expect(journal).to have_selector "img[src$='default_avatar.png']"
        expect(journal).to have_text user.profile.display_name
        expect(journal).to have_link pickle.name, href: pickle_path(pickle)
        expect(journal).to have_text attrs_journal[:body]
      end

      specify "the first page shoule be shown after a journal has been created", js: true do
        pickle.journals.create(attributes_for(:journal))
        10.times { pickle.journals.create(attributes_for(:journal_lorem)) }

        visit user_path(user)
        click_link '次'
        within '.journal-form' do
          select pickle.name, from: 'journal_pickle_id'
          fill_in 'journal_body', with: '腐ってしまった。'
          expect do
            click_button 'commit'
            sleep 0.5
          end.to change { Journal.count }.by 1
        end
        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.created_journal')

        journals = all "div.journal-card"
        expect(journals.length).to eq Journal.default_per_page
        expect(journals.first).to have_text '腐ってしまった。'
        expect(find("#journal-pagination")).not_to have_link '最初'
        expect(find("#journal-pagination")).not_to have_text '前'

        click_link '次'
        sleep 0.5
        journals = all "div.journal-card"
        expect(journals.length).to eq 2
        expect(journals.last).to have_text attrs_journal[:body]
      end

      specify "user can create a journal on own their pickle's page", js: true do
        visit user_path(user)
        click_link pickle.name
        within '.journal-form' do
          fill_in 'journal_body', with: attrs_journal[:body]
          expect do
            click_button 'commit'
            sleep 0.5
          end.to change { Journal.count }.by 1
        end
        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.created_journal')

        journal = find "#journal_#{Journal.last.id}"
        expect(journal).to have_selector "img[src$='default_avatar.png']"
        expect(journal).to have_text user.profile.display_name
        expect(journal).not_to have_link pickle.name, href: pickle_path(pickle)
        expect(journal).to have_text attrs_journal[:body]
      end

      specify "the first page should be shown after a journal been created", js: true do
        pickle.journals.create(attributes_for(:journal))
        10.times { pickle.journals.create(attributes_for(:journal_lorem)) }

        another_pickle = user.pickles.create(attributes_for(:pickle_celery))
        10.times { another_pickle.journals.create(attributes_for(:journal_lorem)) }

        visit user_path(user)
        click_link pickle.name
        click_link '次'
        within '.journal-form' do
          fill_in 'journal_body', with: '腐ってしまった。'
          expect do
            click_button 'commit'
            sleep 0.5
          end.to change { Journal.count }.by 1
        end
        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.created_journal')

        journals = all "div.journal-card"
        expect(journals.length).to eq Journal.default_per_page
        expect(journals.first).to have_text '腐ってしまった。'
        expect(find("#journal-pagination")).not_to have_link '最初'
        expect(find("#journal-pagination")).not_to have_text '前'

        click_link '次'
        sleep 0.5
        journals = all "div.journal-card"
        expect(journals.length).to eq 2
        expect(journals.last).to have_text attrs_journal[:body]
      end

      specify "user cannot create a journal on another user's page" do
        visit user_path(lena)
        journal_section = find('.journal-section')
        expect(journal_section).not_to have_selector 'form'
      end

      specify "user cannot create a journal on another user's pickle page" do
        visit user_path(lena)
        within('.pickle-section') { click_link pickle_lena.name }
        journal_section = find('.journal-section')
        expect(journal_section).not_to have_selector 'form'
      end
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
      journal_section = find('#journal-list')
      expect(journal_section).not_to have_text t('journals.shared.no_journals_yet')
      expect(journal_section).not_to have_link pickle.name, href: pickle_path(pickle)
      pickle.journals.each_with_index do |journal, i|
        if i < 10
          expect(journal_section).to have_text journal.body
        else
          expect(journal_section).not_to have_text journal.body
        end
      end
      within('.journal-section .pagination') do
        click_link '次'
      end
      expect(journal_section).not_to have_link pickle.name, href: pickle_path(pickle)
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

      journal_section = find('#journal-list')
      expect(journal_section).to have_link href: pickle_path(pickle)
      pickle.journals.each_with_index do |journal, i|
        if i < 10
          expect(journal_section).to have_text journal.body
        else
          expect(journal_section).not_to have_text journal.body
        end
      end
      within('.journal-section .pagination') do
        click_link '次'
      end
      pickle.journals.each_with_index do |journal, i|
        if i < 10
          expect(journal_section).not_to have_text journal.body
        else
          expect(journal_section).to have_text journal.body
        end
      end

      expect(journal_section).not_to have_text t('journals.shared.no_journals_yet')
    end

    context 'there are no journals yet' do
      before { pickle.journals.clear }

      specify "a message is shown on the user's page" do
        visit user_path(user)
        expect(find('.no-journals-yet')).to have_text t('journals.shared.no_journals_yet')
      end

      specify "a message is shown on the pickle's page" do
        visit pickle_path(pickle)
        expect(find('.no-journals-yet')).to have_text t('journals.shared.no_journals_yet')
      end

      specify 'a message is shown on journals page' do
        visit journals_path
        expect(find('.no-journals-yet')).to have_text t('journals.shared.no_journals_yet')
      end
    end

    context 'when user has no pickles' do
      before { user.pickles.clear }

      specify "journal form is not shown on the user's page" do
        visit user_path(user)
        expect(page).not_to have_selector 'div.journal-form-section'
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
        expect(find('#journal-list')).to have_text j.body
      end
      expect(page).to have_link '次', href: journals_path(page: 2)
      expect(page).to have_link '最後', href: journals_path(page: 3)
    end
  end

  describe 'DELETE', js: true do
    let!(:user) { create(:user, :confirmed) }
    let!(:lena) { create(:user_lena) }
    let!(:pickle) { user.pickles.create(attributes_for(:pickle)) }
    let!(:another_pickle) { user.pickles.create(attributes_for(:pickle_celery)) }
    let!(:pickle_lena) { lena.pickles.create(attributes_for(:pickle_kabu)) }

    before { sign_in user }

    context "on the user's page" do
      before do
        20.times do
          [pickle, pickle_lena].each do |p|
            p.journals.create(attributes_for(:journal_lorem))
          end
        end
      end

      specify "user can delete their own journal" do
        target_journal = pickle.journals.first

        visit user_path(user)

        within all('.journal-card').first do |e|
          expect(e).to have_text target_journal.body
          expect do
            page.accept_confirm do
              click_on t('journals.shared.destroy_journal')
            end
            sleep 0.5
          end.to change { Journal.count }.by(-1)
        end

        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.destroyed_journal')
        expect(find('#journal-list')).not_to have_text target_journal.body
      end

      specify 'the current pagenation is shown after the journal has been deleted' do
        prev_journal = user.journals[Journal.default_per_page]
        target_journal = user.journals[Journal.default_per_page + 1]
        next_journal = user.journals[Journal.default_per_page + 2]

        visit user_path(user)
        find('.journal-section').click_on '次'
        sleep 0.5

        within all('.journal-card')[1] do |e|
          expect(e).to have_text target_journal.body
          expect do
            page.accept_confirm do
              click_on t('journals.shared.destroy_journal')
            end
            sleep 0.5
          end.to change { Journal.count }.by(-1)
        end

        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.destroyed_journal')
        find('#journal-list') do |e|
          expect(e).to have_text prev_journal.body
          expect(e).not_to have_text target_journal.body
          expect(e).to have_text next_journal.body
        end
      end
    end

    context "on the pickle's page" do
      before do
        20.times do
          [pickle, another_pickle].each do |p|
            p.journals.create(attributes_for(:journal_lorem))
          end
        end
      end

      specify "user can delete their own journal on the pickle's page" do
        target_journal = pickle.journals.create(attributes_for(:journal))

        visit pickle_path(pickle)

        within all('.journal-card').first do |e|
          expect(e).to have_text target_journal.body
          expect do
            page.accept_confirm do
              click_on t('journals.shared.destroy_journal')
            end
            sleep 0.5
          end.to change { Journal.count }.by(-1)
        end

        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.destroyed_journal')
        expect(find('#journal-list')).not_to have_text target_journal.body
      end

      specify 'the current pagenation is shown after the journal has been deleted' do
        prev_journal = pickle.journals[Journal.default_per_page]
        target_journal = pickle.journals[Journal.default_per_page + 1]
        next_journal = pickle.journals[Journal.default_per_page + 2]

        visit pickle_path(pickle)
        find('.journal-section').click_on '次'
        sleep 0.5

        within all('.journal-card')[1] do |e|
          expect(e).to have_text target_journal.body
          expect do
            page.accept_confirm do
              click_on t('journals.shared.destroy_journal')
            end
            sleep 0.5
          end.to change { Journal.count }.by(-1)
        end

        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.destroyed_journal')
        find('#journal-list') do |e|
          expect(e).to have_text prev_journal.body
          expect(e).not_to have_text target_journal.body
          expect(e).to have_text next_journal.body
        end
      end
    end

    context 'on journals page' do
      before do
        20.times do
          [pickle, pickle_lena].each do |p|
            p.journals.create(attributes_for(:journal_lorem))
          end
        end
      end

      specify "user can delete their own journal on journals page" do
        target_journal = pickle.journals.create(attributes_for(:journal))

        visit journals_path
        within all('.journal-card').first do |e|
          expect(e).to have_text target_journal.body
          expect do
            page.accept_confirm do
              click_on t('journals.shared.destroy_journal')
            end
            sleep 0.5
          end.to change { Journal.count }.by(-1)
        end

        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.destroyed_journal')
        expect(find('#journal-list')).not_to have_text target_journal.body
      end

      specify 'the current pagenation is shown after the journal has been deleted' do
        journals = Journal.order(created_at: :desc)
        prev_journal = journals[Journal.default_per_page]
        target_journal = journals[Journal.default_per_page + 1]
        next_journal = journals[Journal.default_per_page + 2]

        visit journals_path
        find('.journal-section').click_on '次'
        sleep 0.5

        within all('.journal-card')[1] do |e|
          expect(e).to have_text target_journal.body
          expect do
            page.accept_confirm do
              click_on t('journals.shared.destroy_journal')
            end
            sleep 0.5
          end.to change { Journal.count }.by(-1)
        end

        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.destroyed_journal')
        find('#journal-list') do |e|
          expect(e).to have_text prev_journal.body
          expect(e).not_to have_text target_journal.body
          expect(e).to have_text next_journal.body
        end
      end
    end

    context 'on top page' do
      specify "user can delete their own journal on top page" do
        target_journal = pickle.journals.create(attributes_for(:journal))

        visit root_path
        within all('.journal-card').first do |e|
          expect(e).to have_text target_journal.body
          expect do
            page.accept_confirm do
              click_on t('journals.shared.destroy_journal')
            end
            sleep 0.5
          end.to change { Journal.count }.by(-1)
        end

        expect(page).to have_selector 'div.alert-success', text: t('journals.shared.destroyed_journal')
        expect(find('#journal-list')).not_to have_text target_journal.body
      end
    end

    context "on another user's page" do
      before do
        20.times do
          [pickle, pickle_lena].each do |p|
            p.journals.create(attributes_for(:journal_lorem))
          end
        end
      end

      specify "user cannot delete others' journal" do
        journal_lena = pickle_lena.journals.first

        visit user_path(lena)
        expect(find('#journal-list')).to have_text journal_lena.body
        expect(find('#journal-list')).not_to have_text t('journals.shared.destroy_journal')
        within '.pickle-section' do
          click_link pickle_lena.name
        end
        expect(find('#journal-list')).to have_text journal_lena.body
        expect(find('#journal-list')).not_to have_text t('journals.shared.destroy_journal')
      end
    end
  end
end
