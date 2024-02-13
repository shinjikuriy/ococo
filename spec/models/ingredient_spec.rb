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
  let(:user) { create(:user, :confirmed) }
  let(:pickle) { user.pickles.create(attributes_for(:pickle)) }
  let(:attrs) { attributes_for :ingredient }

  describe 'dependency' do
    specify 'pickle can have many ingredients' do
      expect(pickle.ingredients.size).to eq 3
    end

    specify 'ingredients are destroyed when pickle is destroyed' do
      ingredient = pickle.ingredients.create(attrs)
      pickle.destroy
      expect(ingredient).to be_destroyed
    end
  end

  describe 'validation' do
    context 'when values are valid' do
      specify 'pickle can create a new ingredient' do
        ingredient = pickle.ingredients.create(attrs)
        expect(ingredient.reload).to be_persisted
      end
    end

    context 'when values are invalid' do
      specify 'name cannot be empty' do
        ingredient = Ingredient.new(name: '', quantity: attrs[:quantity])
        ingredient.valid?
        expect(ingredient.errors[:name]).to include t('errors.messages.blank')
      end

      specify 'name cannot be over 100 characters' do
        ingredient = Ingredient.new(name: 'a' * 101)
        ingredient.valid?
        expect(ingredient.errors[:name]).to include t('errors.messages.too_long', count: 100)
      end

      specify 'quantity cannot be empty' do
        ingredient = Ingredient.new(name: attrs[:name], quantity: '')
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
