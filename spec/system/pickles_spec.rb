require 'rails_helper'

RSpec.describe "Pickles", type: :system do
  let(:user) { create(:user, :confirmed) }
  let(:attrs_pickle) { attributes_for(:pickle) }

  describe 'CREATE' do
    before do
      sign_in user
      visit user_path(user)
      click_on t('pickles.shared.links.create_pickle')

      fill_in 'pickle_name', with: attrs_pickle[:name]
      within '.ingredient-form' do
        attrs_pickle[:ingredients_attributes].each do |ingredient|
          all(id: /pickle_ingredients_attributes_\d+_name/).last.fill_in with: ingredient[:name]
          all(id: /pickle_ingredients_attributes_\d+_quantity/).last.fill_in with: ingredient[:quantity]
          click_link t('pickles.shared.add_ingredient')
        end
      end
      within '.sauce-material-form' do
        attrs_pickle[:sauce_materials_attributes].each do |sauce_material|
          all(id: /pickle_sauce_materials_attributes_\d+_name/).last.fill_in with: sauce_material[:name]
          all(id: /pickle_sauce_materials_attributes_\d+_quantity/).last.fill_in with: sauce_material[:quantity]
          click_link t('pickles.shared.add_ingredient')
        end
      end
      fill_in 'pickle_preparation', with: attrs_pickle[:preparation]
      fill_in 'pickle_process', with: attrs_pickle[:process]
      fill_in 'pickle_note', with: attrs_pickle[:note]
    end

    specify 'user can create a new pickle', js: true do
      expect(find('#pickle_started_on')['value']).to eq Time.zone.today.strftime

      expect do
        click_button t('pickles.new.create_pickle')
        sleep 0.5
      end.to change { Pickle.count }.by 1

      expect(page).to have_current_path pickle_path(user.pickles.first)
      expect(page).to have_selector 'div.alert-success', text: t('pickles.new.created_pickle')
      expect(page).to have_text attrs_pickle[:name]
      attrs_pickle[:ingredients_attributes].each do |ingredient|
        expect(find('.ingredients')).to have_text ingredient[:name]
        expect(find('.ingredients')).to have_text ingredient[:quantity]
      end
      attrs_pickle[:sauce_materials_attributes].each do |sauce_material|
        expect(find('.sauce-materials')).to have_text sauce_material[:name]
        expect(find('.sauce-materials')).to have_text sauce_material[:quantity]
      end
      attrs_pickle[:preparation].each_line { |line| expect(page).to have_text line.chomp }
      attrs_pickle[:process].each_line { |line| expect(page).to have_text line.chomp }
      attrs_pickle[:note].each_line { |line| expect(page).to have_text line.chomp }
    end

    specify "user cannnot create other user's pickles" do
      lena = create(:user_lena)
      lena.confirm

      visit user_path(lena)
      expect(page).not_to have_link t('pickles.new.create_pickle')
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

      specify 'an alert appears when pickle name is over 100 characters' do
        fill_in 'pickle_name', with: 'a' * 101
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Pickle.human_attribute_name(:name).concat(t('errors.messages.too_long', count: 100))
      end

      specify 'an alert appears when preparation is ove 400 characters' do
        fill_in 'pickle_preparation', with: 'a' * 401
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Pickle.human_attribute_name(:preparation).concat(t('errors.messages.too_long', count: 400))
      end

      specify 'an alert appears when processing is over 400 characters' do
        fill_in 'pickle_process', with: 'a' * 401
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Pickle.human_attribute_name(:process).concat(t('errors.messages.too_long', count: 400))
      end

      specify 'an alert appears when note is over 400 characters' do
        fill_in 'pickle_note', with: 'a' * 401
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Pickle.human_attribute_name(:note).concat(t('errors.messages.too_long', count: 400))
      end

      specify 'an alert appears when ingredient_name is over 100 characters' do
        fill_in 'pickle_ingredients_attributes_0_name', with: 'a' * 101
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: '名前'.concat(t('errors.messages.too_long', count: 100))
      end

      specify 'an alert appears when ingredient_quantity is over 100 characters' do
        fill_in 'pickle_ingredients_attributes_0_quantity', with: 'a' * 101
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: '分量'.concat(t('errors.messages.too_long', count: 100))
      end

      specify 'an alert appears when sauce_material_name is over 100 characters' do
        fill_in 'pickle_sauce_materials_attributes_0_name', with: 'a' * 101
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: '名前'.concat(t('errors.messages.too_long', count: 100))
      end

      specify 'an alert appears when sauce_material_quantity is over 100 characters' do
        fill_in 'pickle_sauce_materials_attributes_0_quantity', with: 'a' * 101
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: '分量'.concat(t('errors.messages.too_long', count: 100))
      end

      specify 'an alert appears when either ingredient name or quantity is blank' do
        fill_in 'pickle_ingredients_attributes_0_name', with: ''
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Ingredient.human_attribute_name(:name).concat(t('errors.messages.blank'))

        fill_in 'pickle_ingredients_attributes_0_name', with: attrs_pickle[:ingredients_attributes][0][:name]
        fill_in 'pickle_ingredients_attributes_0_quantity', with: ''
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: Ingredient.human_attribute_name(:quantity).concat(t('errors.messages.blank'))
      end

      specify 'an alert appears when either sauce_material name or quantity is blank' do
        fill_in 'pickle_sauce_materials_attributes_0_name', with: ''
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: SauceMaterial.human_attribute_name(:name).concat(t('errors.messages.blank'))

        fill_in 'pickle_sauce_materials_attributes_0_name', with: attrs_pickle[:sauce_materials_attributes][0][:name]
        fill_in 'pickle_sauce_materials_attributes_0_quantity', with: ''
        click_button 'commit'
        expect(page).to have_selector 'div.alert-warning', text: SauceMaterial.human_attribute_name(:quantity).concat(t('errors.messages.blank'))
      end
    end
  end

  describe 'READ' do
    specify 'anyone can view a pickle page' do
      pickle = user.pickles.create(attrs_pickle)

      visit pickle_path(pickle)
      expect(page).to have_current_path pickle_path(pickle)
      expect(page).to have_text pickle.name
      expect(page).to have_text l(pickle.started_on, format: :long)
      pickle.ingredients.each do |ingredient|
        expect(find('.ingredients')).to have_text ingredient.name
        expect(find('.ingredients')).to have_text ingredient.quantity
      end
      pickle.sauce_materials.each do |sauce_material|
        expect(find('.sauce-materials')).to have_text sauce_material.name
        expect(find('.sauce-materials')).to have_text sauce_material.quantity
      end
      pickle.preparation.each_line { |line| expect(page).to have_text line.chomp }
      pickle.process.each_line { |line| expect(page).to have_text line.chomp }
      pickle.note.each_line { |line| expect(page).to have_text line.chomp }
    end

    specify "user's pickles are shown on user's page" do
      pickle_daikon = user.pickles.create(attributes_for(:pickle_daikon))
      pickle_kabu = user.pickles.create(attributes_for(:pickle_kabu))

      visit user_path(user)
      expect(page).to have_link pickle_daikon.name, href: pickle_path(pickle_daikon)
      expect(page).to have_link pickle_kabu.name, href: pickle_path(pickle_kabu)
    end

    specify "user's pickles are paginated" do
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
      pickles.page(1).per(5).each do |pickle|
        expect(page).to have_link pickle.name, href: pickle_path(pickle)
      end
      expect(page).to have_link '次', href: user_path(user, page: 2)
      expect(page).to have_link '最後', href: user_path(user, page: 10)
    end

    specify 'all pickles are shown on index page' do
      lukas = user
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

      pickles = Pickle.order(created_at: :desc)

      visit pickles_path
      pickles[0..9].each do |pickle|
        expect(page).to have_link pickle.name, href: pickle_path(pickle)
      end

      expect(page).to have_link '次', href: pickles_path(page: 2)
      expect(page).to have_link '最後', href: pickles_path(page: 9)
    end
  end

  describe 'UPDATE' do
    let!(:pickle) { user.pickles.create(attrs_pickle) }
    before do
      sign_in user
      visit user_path(user)
      click_link pickle.name
      click_link t('pickles.shared.links.edit_pickle'), href: edit_pickle_path(pickle)
    end

    specify "user can edit pickles' information" do
      fill_in 'pickle_name', with: '大根の🥑はりはり漬け🌶'
      fill_in 'pickle_started_on', with: Date.new(2020, 1, 1)
      fill_in 'pickle_ingredients_attributes_0_name', with: '新しい材料の名前'
      fill_in 'pickle_ingredients_attributes_0_quantity', with: '新しい材料の数量'
      fill_in 'pickle_sauce_materials_attributes_0_name', with: '新しい漬け汁材料の名前'
      fill_in 'pickle_sauce_materials_attributes_0_quantity', with: '新しい漬け汁材料の数量'
      fill_in 'pickle_preparation', with: '新しい下ごしらえの文章'
      fill_in 'pickle_process', with: '新しい作り方の文章'
      fill_in 'pickle_note', with: '新しいポイントの文章'

      click_button t('pickles.edit.edit_pickle')
      expect(page).to have_current_path pickle_path(pickle)
      expect(page).to have_selector 'div.alert-success', text: t('pickles.edit.edited_pickle')
      expect(page).to have_text '大根の🥑はりはり漬け🌶'
      expect(page).to have_text '2020年01月01日(水)'
      expect(page).to have_text '新しい下ごしらえの文章'
      expect(page).to have_text '新しい作り方の文章'
      expect(page).to have_text '新しいポイントの文章'
      expect(page).to have_text '新しい材料の名前'
      expect(page).to have_text '新しい材料の数量'
      expect(page).to have_text '新しい漬け汁材料の名前'
      expect(page).to have_text '新しい漬け汁材料の数量'
    end

    specify "user cannot edit other user's pickles" do
      lena = create(:user_lena)
      lena.confirm
      lena_pickle = lena.pickles.create(attributes_for(:pickle_kabu))

      visit edit_pickle_path(lena_pickle)
      expect(page).to have_current_path pickle_path(lena_pickle)
    end

    specify 'user can delete ingredients', js: true do
      within '.ingredient-form' do
        all('.nested-fields').last.find_link(t('pickles.shared.delete')).click
      end
      click_button t('pickles.edit.edit_pickle')
      expect(page).to have_current_path pickle_path(pickle)
      expect(page).to have_selector 'div.alert-success', text: t('pickles.edit.edited_pickle')
      expect(page).to have_text attrs_pickle[:name]
      deleted_ingredient = attrs_pickle[:ingredients_attributes].pop
      expect(find('.ingredients')).not_to have_text deleted_ingredient[:name]
      expect(find('.ingredients')).not_to have_text deleted_ingredient[:quantity]
      attrs_pickle[:ingredients_attributes].each do |ingredient|
        expect(find('.ingredients')).to have_text ingredient[:name]
        expect(find('.ingredients')).to have_text ingredient[:quantity]
      end
      attrs_pickle[:sauce_materials_attributes].each do |sauce_material|
        expect(find('.sauce-materials')).to have_text sauce_material[:name]
        expect(find('.sauce-materials')).to have_text sauce_material[:quantity]
      end
      attrs_pickle[:preparation].each_line { |line| expect(page).to have_text line.chomp }
      attrs_pickle[:process].each_line { |line| expect(page).to have_text line.chomp }
      attrs_pickle[:note].each_line { |line| expect(page).to have_text line.chomp }
    end

    specify 'an alert appears when user tries to delete all the ingredients', js: true do
      within '.ingredient-form' do
        attrs_pickle[:ingredients_attributes].size.times do
          all('.nested-fields').first.find_link(t('pickles.shared.delete')).click
        end
      end
      click_button t('pickles.edit.edit_pickle')
      expect(page).to have_selector 'div.alert-warning', text: t('errors.messages.has_no_ingredient')
    end

    specify 'user can delete sauce_materials', js: true do
      within '.sauce-material-form' do
        all('.nested-fields').last.find_link(t('pickles.shared.delete')).click
      end
      click_button t('pickles.edit.edit_pickle')
      expect(page).to have_current_path pickle_path(pickle)
      expect(page).to have_selector 'div.alert-success', text: t('pickles.edit.edited_pickle')
      expect(page).to have_text attrs_pickle[:name]
      deleted_sauce_material = attrs_pickle[:sauce_materials_attributes].pop
      expect(find('.ingredients')).not_to have_text deleted_sauce_material[:name]
      expect(find('.ingredients')).not_to have_text deleted_sauce_material[:quantity]
      attrs_pickle[:ingredients_attributes].each do |ingredient|
        expect(find('.ingredients')).to have_text ingredient[:name]
        expect(find('.ingredients')).to have_text ingredient[:quantity]
      end
      attrs_pickle[:sauce_materials_attributes].each do |sauce_material|
        expect(find('.sauce-materials')).to have_text sauce_material[:name]
        expect(find('.sauce-materials')).to have_text sauce_material[:quantity]
      end
      attrs_pickle[:preparation].each_line { |line| expect(page).to have_text line.chomp }
      attrs_pickle[:process].each_line { |line| expect(page).to have_text line.chomp }
      attrs_pickle[:note].each_line { |line| expect(page).to have_text line.chomp }
    end
  end

  describe 'DELETE' do
    specify 'user can delete pickles', js: true do
      sign_in user
      pickle = user.pickles.create(attributes_for(:pickle))

      visit pickle_path(pickle)
      click_link t('pickles.shared.links.edit_pickle'), href: edit_pickle_path(pickle)
      expect do
        page.accept_confirm do
          click_link t('pickles.destroy.destroy_pickle')
        end
        sleep 0.5
      end.to change { user.pickles.count }.by(-1)
      expect(page).to have_current_path user_path(user)
      expect(page).to have_selector 'div.alert-success', text: t('pickles.shared.destroyed_pickle')
    end
  end
end
