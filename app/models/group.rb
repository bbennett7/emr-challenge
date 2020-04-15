class Group < ApplicationRecord
  has_many :policies
  has_many :members
  belongs_to :provider
  belongs_to :plan
end
