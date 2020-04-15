class Group < ApplicationRecord
  has_many :policies
  has_many :members
  belongs_to :provider
  belongs_to :plan

  validates :provider_id, presence: { message: 'cannot be blank.' }
  validates :group_number, presence: { message: 'cannot be blank.' }
  validates :group_name, presence: { message: 'cannot be blank.' }
end
