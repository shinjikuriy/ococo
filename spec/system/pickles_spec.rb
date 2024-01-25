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

      visit show_user_path(user)
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
    specify "user's pickles are shown on user's page"
  end

  describe 'update' do
    specify "user can edit pickles' information"
  end

  describe 'delete' do
    xspecify 'user can delete pickles'
  end
end
