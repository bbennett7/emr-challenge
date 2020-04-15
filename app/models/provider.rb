class Provider < ApplicationRecord
  has_many :members
  has_many :plans
  has_many :groups
end
