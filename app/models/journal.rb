class Journal < ApplicationRecord
  belongs_to :pickle
  has_one :user, through: :pickle
end
