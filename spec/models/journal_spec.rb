require 'rails_helper'

RSpec.describe Journal, type: :model do
  describe 'dependency' do
    let!(:user) { create(:user) }
    let!(:pickle) { user.pickles.create(attributes_for(:pickle)) }

    specify 'a pickle can have many journals' do
      Journal.create(pickle_id: pickle.id, body: 'ほげほげ')
      Journal.create(pickle_id: pickle.id, body: 'ふがふが')

      expect(pickle.journals.size).to eq 2
      expect(pickle.journals.first.body).to eq 'ほげほげ'
      expect(pickle.journals.second.body).to eq 'ふがふが'
    end

    specify 'a user can have many journals' do
      Journal.create(pickle_id: pickle.id, body: 'ほげほげ')
      Journal.create(pickle_id: pickle.id, body: 'ふがふが')

      expect(user.journals.size).to eq 2
      expect(user.journals.first.body).to eq 'ほげほげ'
      expect(user.journals.second.body).to eq 'ふがふが'
    end
  end

  describe 'validation' do
    specify 'body cannot be blank'
    specify 'body cannot be over 140 characters'
  end
end
