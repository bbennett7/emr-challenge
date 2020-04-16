class Provider < ApplicationRecord
  has_many :members
  has_many :plans
  has_many :groups
  has_many :policies, through: :groups

  validates :provider_name, presence: { message: 'cannot be blank.' }, uniqueness: { message: 'already exists in the database.'}
end
