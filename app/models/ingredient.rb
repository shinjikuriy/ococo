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

  with_options presence: true, length: { maximum: 100 } do
    validates :name
    validates :quantity
  end
end
