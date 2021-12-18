class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :keyword

  validates :keyword_id, :user_id, presence: true
end
