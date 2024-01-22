# == Schema Information
#
# Table name: pickles
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  name        :string
#  started_on  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  preparation :text
#  process     :text
#  note        :text
#
require 'rails_helper'

RSpec.describe Pickle, type: :model do
  let(:attrs) { attributes_for(:pickle) }

  describe 'dependency' do
    specify 'user can have many pickles' do
      user = create(:user)
      user.pickles.create(name: '白菜の浅漬')
      user.pickles.create(name: 'きゅうりのぬか漬け')
      expect(user.pickles.size).to eq 2
    end
  end

  describe 'initialisation' do
    specify 'started_on is set to the date pickle is created on by default' do
      user = create(:user)
      pickle = user.pickles.create(name: attrs[:name])
      expect(pickle).to be_valid
      expect(pickle.started_on).to eq Date.today
    end
  end

  describe 'validation' do
    context 'when values are valid' do
      specify 'user can create a pickle' do
        user = create(:user)
        pickle = user.pickles.create(attrs)
        expect(pickle).to be_valid
      end
    end

    context 'when values are not valid' do
      specify 'name cannot be blank' do
        pickle = Pickle.new(name: '')
        pickle.valid?
        expect(pickle.errors[:name]).to include t('errors.messages.blank')
      end

      specify 'name cannot be over 100 characters' do
        pickle = Pickle.new(name: 'a' * 101)
        pickle.valid?
        expect(pickle.errors[:name]).to include t('errors.messages.too_long', count: 100)
      end
    end
  end
end
