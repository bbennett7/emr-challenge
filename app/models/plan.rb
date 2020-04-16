class Plan < ApplicationRecord
  has_many :members
  has_many :groups
  has_many :policies, through: :groups 
  belongs_to :provider

  validates :provider_id, presence: { message: 'cannot be blank.' }
  validates :plan_name, presence: { message: 'cannot be blank.' }
end
