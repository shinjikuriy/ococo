# == Schema Information
#
# Table name: journals
#
#  id         :bigint           not null, primary key
#  pickle_id  :bigint           not null
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
    specify 'body cannot be blank' do
      journal = Journal.new(body: '')
      journal.valid?
      expect(journal.errors[:body]).to include t('errors.messages.blank')
    end

    specify 'body cannot be over 140 characters' do
      journal = Journal.new(body: 'a' * 141)
      journal.valid?
      expect(journal.errors[:body]).to include t('errors.messages.too_long', count: 140)
    end
  end
end
