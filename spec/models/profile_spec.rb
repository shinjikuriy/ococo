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

    specify 'prefecture can be shown in Japanese' do
      expect(profile.human_attribute_enum(:prefecture)).to eq '未選択'
    end

    specify 'default avatar is set by default' do
      expect(profile.avatar).to be_attached
      expect(profile.avatar.filename).to eq 'default_avatar.png'
    end
  end

  describe 'edit attributes' do
    let!(:user) { create(:user) }
    before { user.confirm }
    let!(:profile) { user.profile }

    it 'can edit display_name' do
      profile.display_name = 'ルーカス'
      profile.save
      expect(profile.display_name).to eq 'ルーカス'
    end

    it 'can edit prefecture' do
      profile.prefecture = :aomori
      profile.save
      expect(profile.prefecture).to eq 'aomori'
      expect(profile.human_attribute_enum(:prefecture)).to eq '青森'
    end

    it 'can change avatar' do
      profile.avatar.attach(io: File.open("#{Rails.root}/spec/fixtures/avatar_cat.png"), filename: 'avatar_cat.png', content_type: 'image/png')
      profile.save
      expect(profile.avatar.filename).to eq 'avatar_cat.png'
    end
  end
end
