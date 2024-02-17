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
class NamespaceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value =~ PathRegex.root_namespace_path_regex
      record.errors.add(attribute, I18n.t('errors.messages.taken'))
    end
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  attr_writer :login

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  has_many :pickles, dependent: :destroy
  has_many :journals, -> { order(created_at: :desc) }, through: :pickles

  validates :username, presence: true, length: { minimum: 3, maximum: 30 }, uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: :invalid_username_format },
                       namespace: true

  before_create :initialize_profile

  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def to_param
    username
  end

  private

  def initialize_profile
    return if profile.present?

    build_profile(display_name: username, prefecture: :unselected)
    profile.avatar.attach io: File.open(Rails.root.join('app/assets/images/default_avatar.png')),
                          filename: 'default_avatar.png', content_type: 'image/png'
  end
end
