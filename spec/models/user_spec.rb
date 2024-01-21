# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  username               :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'varidation' do
    let!(:attrs) { attributes_for(:user) }

    context 'valid attributes' do
      it 'is valid with a username, email and password' do
        user = User.new(attrs)
        expect(user).to be_valid
      end

      it 'has one profile after create' do
        user = User.create(attrs)
        expect(user.profile.display_name).to eq attrs[:username]
        expect(user.profile.prefecture).to eq 'unselected'
      end
    end

    context 'invalid attributes' do
      context 'invalid username' do
        it 'is invalid without a username' do
          user = User.new(username: nil)
          user.valid?
          expect(user.errors[:username]).to include t('errors.messages.empty')
        end

        it 'is invalid with a duplicated username' do
          User.create(attrs)
          another_user = User.new(
            username: attrs[:username],
            email: 'another_user@example.com',
            password: 'another_password'
          )
          another_user.valid?
          expect(another_user.errors[:username]).to include t('errors.messages.taken')
        end

        it 'is invalid with a too short username' do
          user = User.new(username: 'lu')
          user.valid?
          expect(user.errors[:username]).to include t('errors.messages.too_short', count: 3)
        end

        it 'is invalid with a too long username' do
          user = User.new(username: 'call_me_by_this_31_letter_name_')
          user.valid?
          expect(user.errors[:username]).to include t('errors.messages.too_long', count: 30)
        end

        it 'is invalid with invalid characters' do
          user = User.new(username: 'lukas.')
          user.valid?
          expect(user.errors[:username]).to include t('errors.messages.invalid_username_format')
        end
      end

      context 'invalid email' do
        it 'is invalid without an email' do
          user = User.new(email: nil)
          user.valid?
          expect(user.errors[:email]).to include t('errors.messages.empty')
        end

        it 'is invalid with a duplicated email' do
          User.create(attrs)
          another_user = User.new(
            username: 'another_user',
            email: attrs[:email],
            password: 'another_password'
          )
          another_user.valid?
          expect(another_user.errors[:email]).to include t('errors.messages.taken')
        end
      end

      context 'invalid password' do
        it 'is invalid without a password' do
          user = User.new(password: nil)
          user.valid?
          expect(user.errors[:password]).to include t('errors.messages.empty')
        end
      end
    end
  end

  describe '#destroy' do
    let!(:user) { create(:user) }
    let!(:profile) { user.profile }

    it 'should destroy associated stuff too' do
      user.destroy
      expect(profile).to be_destroyed
    end
  end
end
