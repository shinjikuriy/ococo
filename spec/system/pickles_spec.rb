require 'rails_helper'

RSpec.describe "Pickles", type: :system do
  describe 'create' do
    specify 'user can create a new pickle' do
      user = create(:user)
      user.confirm
      sign_in user
      attrs_pickle = attributes_for(:pickle)
      attrs_ingredient = attributes_for(:ingredient)
      attrs_sauce_material = attributes_for(:sauce_material)

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
  end

  describe 'read' do
    specify "user's pickles are shown on user's page" do
      user = create(:user)
      user.confirm
      sign_in user
      pickle_daikon = user.pickles.create(attributes_for(:pickle_daikon))
      pickle_kabu = user.pickles.create(attributes_for(:pickle_kabu))

      visit user_path(user)
      expect(page).to have_text pickle_daikon.name
      expect(page).to have_text pickle_kabu.name
    end
  end

  describe 'update' do
    specify "user can edit pickles' information" do
      user = create(:user)
      user.confirm
      sign_in user
      pickle = user.pickles.create(attributes_for(:pickle_daikon))

      visit user_path(user)
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
      expect(page).to have_current_path user_path(user)
      expect(page).to have_selector 'div.alert-success', text: t('pickles.edit.edited_pickle')
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
