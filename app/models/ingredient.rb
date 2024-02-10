# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  pickle_id  :bigint           not null
#  name       :string
#  quantity   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Ingredient < ApplicationRecord
  belongs_to :pickle

  validates :name, :quantity, presence: true, length: { maximum: 100 }
end
