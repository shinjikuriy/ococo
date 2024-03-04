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
#  description  :text
#  x_username   :text
#  ig_username  :text
#
require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'dependency' do
    specify 'user has one profile' do
      user = create(:user)
      expect(user.profile).to be_persisted
      expect do
        user.create_profile(display_name: user.username, x_username: '', ig_username: '')
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe 'initialisation' do
    let!(:user) { create(:user, :confirmed) }
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

    specify 'description is nil by default' do
      expect(profile.description).to be_nil
    end

    specify 'x_username is nil by default' do
      expect(profile.x_username).to be_nil
    end

    specify 'ig_username is nil by default' do
      expect(profile.ig_username).to be_nil
    end
  end

  describe 'validation' do
    let!(:user) { create(:user) }
    let!(:profile) { user.profile }
    before { user.confirm }

    context 'when new value is valid' do
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
        profile.avatar.attach(io: File.open("#{Rails.root}/spec/fixtures/avatar_cat.png"),
                              filename: 'avatar_cat.png', content_type: 'image/png')
        profile.save
        expect(profile.avatar.filename).to eq 'avatar_cat.png'
      end

      it 'can edit description' do
        profile.description = 'いぶりがっこが好きです。毎週浅漬をつけています。よろしくお願いします。'
        profile.save
        expect(profile.description).to eq 'いぶりがっこが好きです。毎週浅漬をつけています。よろしくお願いします。'
      end

      it 'can edit x_username' do
        profile.x_username = 'luke_x'
        profile.save
        expect(profile.x_username).to eq 'luke_x'
      end

      it 'can edit ig_username' do
        profile.ig_username = 'luke_ig'
        profile.save
        expect(profile.ig_username).to eq 'luke_ig'
      end
    end

    context 'when new value is invalid' do
      it 'does not accept blank display_name' do
        profile.display_name = ''
        profile.valid?
        expect(profile.errors[:display_name]).to include t('errors.messages.required')
      end

      it 'does not accept display_name over 30 characters' do
        profile.display_name = '🐵' * 31
        profile.valid?
        expect(profile.errors[:display_name]).to include t('errors.messages.too_long', count: 30)
      end

      it 'does not accept description over 160 characters' do
        profile.description = '🙈' * 161
        profile.valid?
        expect(profile.errors[:description]).to include t('errors.messages.too_long', count: 160)
      end

      it 'does not accept "luke.x" as x_username' do
        profile.x_username = 'luke.x'
        profile.valid?
        expect(profile.errors[:x_username]).to include t('errors.messages.invalid_username_format')
      end

      it 'does not accept x_username over 15 characters' do
        profile.x_username = 'l' * 16
        profile.valid?
        expect(profile.errors[:x_username]).to include t('errors.messages.too_long', count: 15)
      end

      it 'does not accept "luke_ig!" as ig_username' do
        profile.ig_username = 'luke_ig!'
        profile.valid?
        expect(profile.errors[:ig_username]).to include t('errors.messages.invalid_ig_username_format')
      end

      it 'does not accept ig_username over 30 characters' do
        profile.ig_username = 'a' * 31
        profile.valid?
        expect(profile.errors[:ig_username]).to include t('errors.messages.too_long', count: 30)
      end

      it 'does not accept files except for jpeg, gif, and png' do
        profile.avatar.attach(io: File.open("#{Rails.root}/spec/fixtures/joyo.tsv"),
                              filename: 'joyo.tsv', content_type: 'text/tsv')
        profile.valid?
        expect(profile.errors[:avatar]).to include t('errors.messages.invalid_content_type')
      end

      it 'does not accept files more than 2MB' do
        profile.avatar.attach(io: File.open("#{Rails.root}/spec/fixtures/too_large_file.jpg"),
                              filename: 'too_large_file.jpg', content_type: 'image/jpeg')
        profile.valid?
        expect(profile.errors[:avatar]).to include t('errors.messages.file_size_is_too_large')
      end
    end
  end
end
