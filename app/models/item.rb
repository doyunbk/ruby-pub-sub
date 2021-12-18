class Item < ApplicationRecord

  include Wisper::Publisher

  belongs_to :user

  validates :user_id, presence:true, numericality: { only_integer: true }
  validates :title, presence: true, length: { minimum: 2, maximum: 255 }
  validates :price, presence: true, numericality: { only_integer: true }
  validates :description, presence: true, length: { minimum: 6, maximum: 255 }

  validate :validate_user_id

  # The events of creating items are being broadcasted
  # whether creation of item is successful or unsuccessful 
  def commit(_attrs = nil)
    assign_attributes(_attrs) if _attrs.present?
    if save
      broadcast(:item_create_successful, self)
    else
      broadcast(:item_create_failed, self)
    end
  end

  private

  def validate_user_id
    errors.add(:user_id, "user id is invalid") unless User.exists?(self.user_id)
  end

end
