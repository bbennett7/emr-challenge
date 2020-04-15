class Member < ApplicationRecord
  belongs_to :policy
  belongs_to :group
  belongs_to :plan
  belongs_to :provider
end
