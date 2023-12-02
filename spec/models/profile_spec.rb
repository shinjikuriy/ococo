# == Schema Information
#
# Table name: profiles
#
#  id           :bigint           not null, primary key
#  user_id      :bigint
#  display_name :string(30)
#  prefecture   :integer          default("unselected"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'initialization' do
    let!(:user) { create(:user) }
    before { user.confirm }
    let!(:profile) { user.profile }

    specify 'display_name is as same as username by default' do
      expect(profile.display_name).to eq 'lukas'
    end

    specify 'prefecture is unselected by default' do
      expect(profile.prefecture).to eq 'unselected'
    end
  end
end
