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
FactoryBot.define do
  factory :ingredient do
    name { "大根" }
    quantity { "1本" }
  end

  factory :ingredient_lorem, class: Ingredient do
    name { Faker::Food.vegetables }
    quantity { Faker::Food.measurement }
  end
end
