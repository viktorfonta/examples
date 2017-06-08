class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :preference_id, :preference_type, :action_completed, :sender, :created_at,
                  :attachment_url, :attachment_name, :conversation_id, :image_width, :image_height

  def preference_id
    object.preference.attached_id if object.preference
  end

  def preference_type
    object.preference.attached_type if object.preference
  end

  def action_completed
    object.preference.action_completed if object.preference
  end

  def attachment_url
    object.preference.attachment_url if object.preference
  end

  def attachment_name
    object.preference.attachment_name if object.preference
  end

  def image_width
    object.preference.width if object.preference
  end

  def image_height
    object.preference.height if object.preference
  end

  def created_at
    object.created_at.to_datetime.to_s
  end

  def sender
    @sender = object.sender
    {
      name: @sender.name,
      id: @sender.id,
      profile_photo: @sender.profile_photo,
      role: @sender.role,
      has_direct_scheduler_session: current_user ? current_user.has_direct_scheduler_session(@sender) : nil
    }
  end

  private

  def current_user
    Thread.current[:user]
  end

end
