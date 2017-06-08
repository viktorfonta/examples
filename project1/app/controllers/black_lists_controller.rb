class BlackListsController < APIController
  skip_before_filter :initialize_service
  before_filter :load_conversation, only: [:create, :destroy]
  before_filter :set_current_user, only: [:index]

  def create
    @conversation.left_users.create(user_id: current_user.id)
    _render_json_success_pretty
  end

  def destroy
    @conversation.left_users.where(user_id: current_user.id).first.destroy
    _render_json_success_pretty
  end

  def index
    conversations = current_user.mailbox.conversations.joins(:left_users).where(is_group: false)
    render json: {status: "OK",
                  conversations: ActiveModel::ArraySerializer.new(conversations,
                                                                  each_serializer: ConversationBlackListSerializer,
                                                                  root: nil)
           }
  end

  private

  def load_conversation
    @conversation = current_user.mailbox.conversations.find(params[:id] || params[:conversaction_id])
  end

  def set_current_user
    Thread.current[:user] = current_user
  end
end