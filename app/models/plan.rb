class Plan < ApplicationRecord
  has_many :members
  has_many :groups
  has_many :policies, through: :groups 
  belongs_to :provider
end
