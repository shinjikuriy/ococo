require 'rails_helper'

RSpec.describe "Pickles", type: :system do
  describe 'create' do
    let!(:user) { create(:user) }
    let!(:attrs_pickle) { attributes_for(:pickle) }
    let!(:attrs_ingredient) { attributes_for(:ingredient) }
    let!(:attrs_sauce_material) { attributes_for(:sauce_material) }
    before do
      user.confirm
      sign_in user
    end

    specify 'user can create a new pickle' do
      visit user_path(user)
      click_on t('pickles.shared.links.create_pickle')

      # should test multiple ingredients/sauce_materials acceptance
      expect {
        fill_in 'pickle[name]', with: attrs_pickle[:name]
        fill_in 'pickle[ingredients_attributes][0][name]', with: attrs_ingredient[:name]
        fill_in 'pickle[ingredients_attributes][0][quantity]', with: attrs_ingredient[:quantity]
        fill_in 'pickle[sauce_materials_attributes][0][name]', with: attrs_sauce_material[:name]
        fill_in 'pickle[sauce_materials_attributes][0][quantity]', with: attrs_sauce_material[:quantity]
        fill_in 'pickle[preparation]', with: attrs_pickle[:preparation]
        fill_in 'pickle[process]', with: attrs_pickle[:process]
        fill_in 'pickle[note]', with: attrs_pickle[:note]
        click_button t('pickles.new.create_pickle')
      }.to change { Pickle.count }.by 1

      expect(page).to have_current_path pickle_path(user.pickles.first)
      expect(page).to have_selector 'div.alert-success', text: t('pickles.new.created_pickle')
    end

    context 'when values are invalid' do
      specify 'alerts appear for unentered fields' do
        visit user_path(user)
        click_on t('pickles.shared.links.create_pickle')
        click_button 'commit'

        expect(page).to have_selector 'div.alert-warning', text: Pickle.human_attribute_name(:name).concat(t('errors.messages.blank'))
        expect(page).to have_selector 'div.alert-warning', text: Pickle.human_attribute_name(:process).concat(t('errors.messages.blank'))
        expect(page).to have_selector 'div.alert-warning', text: Ingredient.model_name.human.concat(t('errors.messages.blank'))
      end
    end
  end

  describe 'read' do
    specify 'anyone can view a pickle page' do
      user = create(:user)
      user.confirm
      pickle = user.pickles.build(attributes_for(:pickle))
      pickle.ingredients.build(attributes_for(:ingredient))
      pickle.save!

      visit pickle_path(pickle)
      expect(page).to have_current_path pickle_path(pickle)
      expect(page).to have_text pickle.name
      pickle.preparation.each_line { |line| expect(page).to have_text line.chomp }
      pickle.process.each_line { |line| expect(page).to have_text line.chomp }
      pickle.note.each_line { |line| expect(page).to have_text line.chomp }
      pickle.ingredients.each do |ingredient|
        expect(page).to have_text ingredient.name
        expect(page).to have_text ingredient.quantity
      end
      pickle.sauce_materials.each do |sauce_material|
        expect(page).to have_text sauce_material.name
        expect(page).to have_text sauce_material.quantity
      end
    end

    specify "user's pickles are shown on user's page" do
      user = create(:user)
      user.confirm
      pickle_daikon = user.pickles.build(attributes_for(:pickle_daikon))
      pickle_daikon.ingredients.build(attributes_for(:ingredient))
      pickle_daikon.save!
      pickle_kabu = user.pickles.build(attributes_for(:pickle_kabu))
      pickle_kabu.ingredients.build(attributes_for(:ingredient))
      pickle_kabu.save!

      visit user_path(user)
      expect(page).to have_link pickle_daikon.name, href: pickle_path(pickle_daikon)
      expect(page).to have_link pickle_kabu.name, href: pickle_path(pickle_kabu)
    end

    specify "user's pickles are paginated" do
      user = create(:user)
      user.confirm
      50.times do
        pickle = user.pickles.build(
          name: Faker::Food.dish,
          preparation: Faker::Lorem.sentence(word_count: 3),
          process: Faker::Food.description,
          note: Faker::Lorem.sentence(word_count: 5)
        )
        pickle.ingredients.build(attributes_for(:ingredient))
        pickle.save!
      end
      pickles = user.pickles.order(updated_at: :desc)

      visit user_path(user)
      pickles.page(1).each do |pickle|
        expect(page).to have_link pickle.name, href: pickle_path(pickle)
      end
      expect(page).to have_link '次', href: user_path(user, page: 2)
      expect(page).to have_link '最後', href: user_path(user, page: 5)
    end

    specify 'all pickles are shown on index page' do
      lukas = create(:user)
      lena = create(:user_lena)
      stefan = create(:user_stefan)

      [lukas, lena, stefan].each do |u|
        u.confirm
        sign_in u
      end

      30.times do
        [lukas, lena, stefan].each do |u|
          pickle = u.pickles.build(
            name: Faker::Food.dish,
            preparation: Faker::Lorem.sentence(word_count: 3),
            process: Faker::Food.description,
            note: Faker::Lorem.sentence(word_count: 5)
          )
          pickle.ingredients.build(attributes_for(:ingredient))
          pickle.save!
        end
      end

      pickles = Pickle.all.order(created_at: :desc)

      visit pickles_path
      pickles[0..9].each do |pickle|
        expect(page).to have_link pickle.name, href: pickle_path(pickle)
      end

      expect(page).to have_link '次', href: pickles_path(page: 2)
      expect(page).to have_link '最後', href: pickles_path(page: 9)
    end
  end

  describe 'update' do
    specify "user can edit pickles' information" do
      user = create(:user)
      user.confirm
      sign_in user
      pickle = user.pickles.create(attributes_for(:pickle_daikon).merge(ingredients_attributes: [attributes_for(:ingredient)]))

      visit user_path(user)
      click_link user.pickles.last.name
      click_link t('pickles.shared.links.edit_pickle'), href: edit_pickle_path(pickle)
      fill_in 'pickle[name]', with: '大根のはりはり漬け🌶'
      fill_in 'pickle[preparation]', with: '新しい下ごしらえの文章'
      fill_in 'pickle[process]', with: '新しい作り方の文章'
      fill_in 'pickle[note]', with: '新しいポイントの文章'
      fill_in 'pickle[ingredients_attributes][0][name]', with: '新しい材料の名前'
      fill_in 'pickle[ingredients_attributes][0][quantity]', with: '新しい材料の数量'
      fill_in 'pickle[sauce_materials_attributes][0][name]', with: '新しい漬け汁材料の名前'
      fill_in 'pickle[sauce_materials_attributes][0][quantity]', with: '新しい漬け汁材料の数量'
      click_button t('pickles.edit.edit_pickle')
      expect(page).to have_current_path pickle_path(pickle)
      expect(page).to have_selector 'div.alert-success', text: t('pickles.edit.edited_pickle')
      expect(page).to have_text '大根のはりはり漬け🌶'
      expect(page).to have_text '新しい下ごしらえの文章'
      expect(page).to have_text '新しい作り方の文章'
      expect(page).to have_text '新しいポイントの文章'
      expect(page).to have_text '新しい材料の名前'
      expect(page).to have_text '新しい材料の数量'
      expect(page).to have_text '新しい漬け汁材料の名前'
      expect(page).to have_text '新しい漬け汁材料の数量'
    end
  end

  describe 'delete' do
    xspecify 'user can delete pickles', js: true do
      user = create(:user)
      user.confirm
      sign_in user
      pickle = user.pickles.create(attributes_for(:pickle_daikon))

      visit user_path(user)
      click_link t('pickles.shared.links.edit_pickle'), href: edit_pickle_path(pickle)
      expect {
        page.accept_confirm do
          click_on t('pickles.destroy_pickle')
        end
      }.to change { Pickle.count }.by(-1)
    end
  end
end
