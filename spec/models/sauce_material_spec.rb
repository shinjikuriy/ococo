# == Schema Information
#
# Table name: sauce_materials
#
#  id         :bigint           not null, primary key
#  pickle_id  :bigint           not null
#  name       :string
#  quantity   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe SauceMaterial, type: :model do
  let(:user) { create(:user, :confirmed) }
  let(:pickle) { user.pickles.create(attributes_for(:pickle)) }
  let(:attrs) { attributes_for :sauce_material }

  describe 'dependency' do
    specify 'pickle can have many sauce_materials' do
      expect(pickle.sauce_materials.size).to eq 4
    end

    specify 'sauce_materials are destroyed when pickle is destroyed' do
      sauce_material = pickle.sauce_materials.create(attrs)
      pickle.destroy
      expect(sauce_material).to be_destroyed
    end
  end

  describe 'validation' do
    context 'when values are valid' do
      specify 'user can successfully create a sauce_material' do
        sauce_material = pickle.sauce_materials.create(attrs)
        expect(sauce_material).to be_persisted
      end
    end

    context 'when values are invalid' do
      specify 'name cannot be empty' do
        sauce_material = SauceMaterial.new(name: '', quantity: attrs[:quantity])
        sauce_material.valid?
        expect(sauce_material.errors[:name]).to include t('errors.messages.blank')
      end

      specify 'name cannot be over 100 characters' do
        sauce_material = SauceMaterial.new(name: 'a' * 101)
        sauce_material.valid?
        expect(sauce_material.errors[:name]).to include t('errors.messages.too_long', count: 100)
      end

      specify 'quantity cannot be empty' do
        sauce_material = SauceMaterial.new(name: attrs[:name], quantity: '')
        sauce_material.valid?
        expect(sauce_material.errors[:quantity]).to include t('errors.messages.blank')
      end

      specify 'quantity cannot be over 100 characters' do
        sauce_material = SauceMaterial.new(quantity: 'a' * 101)
        sauce_material.valid?
        expect(sauce_material.errors[:quantity]).to include t('errors.messages.too_long', count: 100)
      end
    end
  end
end
