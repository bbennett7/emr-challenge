class Policy < ApplicationRecord
  belongs_to :group
  has_one :member
end
