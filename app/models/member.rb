class Member < ApplicationRecord
  belongs_to :policy
  belongs_to :group
  belongs_to :plan
  belongs_to :provider

  validates :provider_id, presence: { message: 'cannot be blank.' }
  validates :member_number, presence: { message: 'cannot be blank.' }
  validates :first_name, presence: { message: 'cannot be blank.' }
  validates :last_name, presence: { message: 'cannot be blank.' }
end
