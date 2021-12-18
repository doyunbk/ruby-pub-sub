class User < ApplicationRecord

    has_many :items, dependent: :destroy
    has_many :keywords, through: :subscriptions
    has_many :subscriptions, dependent: :destroy

    validates :email, presence: true, length: { minimum: 8, maximum: 255 },  uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6, maximum: 255 }

end
