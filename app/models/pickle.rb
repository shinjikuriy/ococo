# == Schema Information
#
# Table name: pickles
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  name       :string
#  started_on :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Pickle < ApplicationRecord
  belongs_to :user
end
