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
  let(:user) { create(:user, :confirmed) }
  let(:pickle) { user.pickles.create(attributes_for(:pickle)) }

  describe 'dependency' do
    specify 'user can have many pickles' do
      user.pickles.create(attributes_for(:pickle_daikon))
      user.pickles.create(attributes_for(:pickle_kabu))
      expect(user.pickles.size).to eq 2
    end

    specify 'pickles are also destroyed when user is destroyed' do
      pickle
      user.destroy
      expect(pickle).to be_destroyed
    end
  end

  describe 'initialisation' do
    specify 'started_on is set to the date pickle is created on by default' do
      expect(pickle.started_on).to eq Date.today
    end
  end

  describe 'validation' do
    context 'when values are valid' do
      specify 'user can create a pickle' do
        expect(pickle).to be_persisted
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

      specify 'preparation cannot be over 400 characters' do
        pickle = Pickle.new(preparation: 'a' * 401)
        pickle.valid?
        expect(pickle.errors[:preparation]).to include t('errors.messages.too_long', count: 400)
      end

      specify 'process cannot be blank' do
        pickle = Pickle.new(process: '')
        pickle.valid?
        expect(pickle.errors[:process]).to include t('errors.messages.blank')
      end

      specify 'process cannot be over 400 characters' do
        pickle = Pickle.new(process: 'a' * 401)
        pickle.valid?
        expect(pickle.errors[:process]).to include t('errors.messages.too_long', count: 400)
      end

      specify 'note cannot be over 400 characters' do
        pickle = Pickle.new(note: 'a' * 401)
        pickle.valid?
        expect(pickle.errors[:note]).to include t('errors.messages.too_long', count: 400)
      end
    end
  end
end
