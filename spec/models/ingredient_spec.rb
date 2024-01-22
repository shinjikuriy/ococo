# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  pickle_id  :bigint           not null
#  name       :string
#  quantity   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  let(:attrs) { attributes_for :ingredient }

  describe 'dependency' do
    specify 'pickle can have many ingredients' do
      user = create(:user)
      pickle = user.pickles.create(attributes_for(:pickle).except(:user_id))
      pickle.ingredients.create(name: '大根', quantity: '1本')
      pickle.ingredients.create(name: 'ごぼう', quantity: '1/2本')
      expect(pickle.ingredients.size).to eq 2
    end
  end

  describe 'validation' do
    context 'when values are valid' do
      specify 'user can successfully create a ingredient' do
        user = create(:user)
        pickle = user.pickles.create(attributes_for(:pickle).except(:user_id))
        pickle.ingredients.create(attrs.except(:pickle_id))
      end
    end

    context 'when values are invalid' do
      specify 'name cannot be empty' do
        ingredient = Ingredient.new(name: '')
        ingredient.valid?
        expect(ingredient.errors[:name]).to include t('errors.messages.blank')
      end

      specify 'name cannot be over 100 characters' do
        ingredient = Ingredient.new(name: 'a' * 101)
        ingredient.valid?
        expect(ingredient.errors[:name]).to include t('errors.messages.too_long', count: 100)
      end

      specify 'quantity cannot be empty' do
        ingredient = Ingredient.new(quantity: '')
        ingredient.valid?
        expect(ingredient.errors[:quantity]).to include t('errors.messages.blank')
      end

      specify 'quantity cannot be over 100 characters' do
        ingredient = Ingredient.new(quantity: 'a' * 101)
        ingredient.valid?
        expect(ingredient.errors[:quantity]).to include t('errors.messages.too_long', count: 100)
      end
    end
  end
end
