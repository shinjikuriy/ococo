# == Schema Information
#
# Table name: pickles
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  name       :string
#  started_on :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Pickle, type: :model do
  describe 'dependency' do
    specify 'user can have many pickles' do
      user = create(:user)
      user.pickles.create(name: '白菜の浅漬')
      user.pickles.create(name: 'きゅうりのぬか漬け')
      expect(user.pickles.size).to eq 2
    end
  end

  describe 'validation' do
    let(:attrs) { attributes_for(:pickle) }

    context 'when values are valid' do
      specify 'user can create a pickle' do
        pickle = Pickle.new(attrs)
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

      specify 'started_on is the date pickle is created by default' do
        pickle = Pickle.create(name: attrs[:name])
        expect(pickle.started_on).to eq Date.today
      end
    end
  end
end
