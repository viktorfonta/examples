class Message < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :receiver, foreign_key: :receiver_id, class_name: "User"
  has_one :mail_notification_real_entity, as: :entity
  before_create :set_receiver_id

  validates :content, presence: true


  def from
    self.sender.display_name
  end

  def sender_info
    {sender_name: self.sender.display_name, sender_profile_photo: self.sender.profile_photo}
  end

  def receiver_info
    {receiver_name: self.receiver.display_name, receiver_profile_photo: self.receiver.profile_photo}
  end

  private

  def set_receiver_id
    if self.receiver_id.blank? && self.parent_id.present?
      parent_msg = Message.find self.parent_id
      self.receiver_id = parent_msg.sender_id
    end
  end
end
