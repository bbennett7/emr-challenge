class Policy < ApplicationRecord
  belongs_to :group
  has_one :member

  validates :group_id, presence: { message: 'cannot be blank.' }
  validates :effective_date, presence: { message: 'cannot be blank.' }
  validates :expiration_date, presence: { message: 'cannot be blank.' }
  validates :policy_number, presence: { message: 'cannot be blank.' }
end
