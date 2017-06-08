class MessagesController < APIController
  before_filter :set_current_user, only: [:create, :feedback]
  skip_before_filter :initialize_service

  def create
    options = create_params
    receivers = options[:receivers] || []
    receivers.push(options[:receiver_id]) unless options[:receiver_id].blank?
    message = MessageService.send_message({sender: current_user,
                                           receivers: receivers,
                                           conversation_id: options[:conversation_id],
                                           content: options[:content],
                                           attachment_url: options[:attachment_url],
                                           attachment_name: options[:attachment_name],
                                           message_type: options[:message_type],
                                           delete_receiver: options[:delete_receiver]
                                          })
    render json: {status: 'OK',
                  conversation: ConversationSerializer.new(Mailboxer::Conversation.find(message.conversation.id)),
                  message: MessageSerializer.new(message)
           }
  end

  def read_conversation
    conversation = current_user.conversations.find_by(id: params[:id])
    conversation.mark_as_read(current_user) if conversation
    _render_json_success_pretty(unread: current_user.mailbox.conversations(mailbox_type: "participant_ex").
                                    not_trash_ex(current_user).not_deleted_ex(current_user).
                                    inbox_ex(current_user).unread_ex(current_user).count)
  end

  def feedback
    AdminMailer.send_feedback({user: current_user, message: params[:message][:content]}).deliver_now
    create
  end

  private

  def create_params
    params.require(:message).permit!
  end

  def set_current_user
    Thread.current[:user] = current_user
  end
end
