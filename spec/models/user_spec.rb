require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'varidation' do
    let!(:attrs){ attributes_for(:user) }

    context 'valid attributes' do
      it 'is valid with a username, email and password' do
        user = User.new(attrs)
        expect(user).to be_valid
      end
    end

    context 'invalid attributes' do
      context 'invalid username' do
        it 'is invalid without a username' do
          user = User.new(username: nil)
          user.valid?
          expect(user.errors[:username]).to include("can't be blank")
        end

        it 'is invalid with a duplicated username' do
          User.create(attrs)
          another_user = User.new(
            username: attrs[:username],
            email: 'another_user@example.com',
            password: 'another_password'
          )
          another_user.valid?
          expect(another_user.errors[:username]).to include('has already been taken')
        end

        it 'is invalid with a too short username' do
          user = User.new(username: 'lu')
          user.valid?
          expect(user.errors[:username]).to include('is too short (minimum is 3 characters)')
        end

        it 'is invalid with invalid characters' do
          user = User.new(username: 'lukas.')
          user.valid?
          expect(user.errors[:username]).to include('is invalid')
        end
      end

      context 'invalid email' do
        it 'is invalid without an email' do
          user = User.new(email: nil)
          user.valid?
          expect(user.errors[:email]).to include("can't be blank")
        end

        it 'is invalid with a duplicated email' do
          User.create(attrs)
          another_user = User.new(
            username: 'another_user',
            email: attrs[:email],
            password: 'another_password'
          )
          another_user.valid?
          expect(another_user.errors[:email]).to include('has already been taken')
        end
      end

      context 'invalid password' do
        it 'is invalid without a password' do
          user = User.new(password: nil)
          user.valid?
          expect(user.errors[:password]).to include("can't be blank")
        end
      end
    end
  end

  describe '#destroy' do
    it 'should destroy associated stuff too'
  end
end
