class LeftUser < ActiveRecord::Base
  include Project1PrivatePub

  belongs_to :user, class_name: 'User'
  belongs_to :conversation, class_name: 'Mailboxer::Conversation'

  validates :user_id, :conversation_id, presence: true
  validates :user_id, uniqueness: { scope: :conversation_id }

  after_create :_after_create
  before_destroy :_before_destroy

  private
  def _after_create
    notify('update.block_user')
  end

  def _before_destroy
    notify('update.unblock_user')
  end

  def notify(type)
    etc_publish_to(channel: '/messages/common',
                   args: { current_user_id: self.user_id,
                           left_user_ids: self.conversation.left_users.map(&:user_id),
                           conversation_id: self.conversation_id,
                           type: type
                   })
  end
end
