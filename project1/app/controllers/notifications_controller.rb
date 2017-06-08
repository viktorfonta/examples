class NotificationsController < APIController
  skip_filter :initialize_service
  before_filter :authenticate_user!

  def index
    notifications = current_user.recieved_notifications.
        order(updated_at: :desc).offset(params[:offset].to_i).
        includes(notification_entities: [:notification_real_entity]).limit(params[:per_page] || PER_PAGE)

    _render_json_success_pretty({
                                    notifications: notifications.as_json(JsonService::NOTIFICATION_LIST),
                                    unread: current_user.recieved_notifications.unread.count
                                })
  end

  def destroy
    current_user.recieved_notifications.find_by_id(params[:id]).try(:destroy) ? _render_json_success_pretty : _render_json_error_pretty
  end

  def remove_all
    current_user.recieved_notifications.destroy_all ? _render_json_success_pretty : _render_json_error_pretty
  end

  def mark_all_as_read
    Notification.mark_all_as_read(current_user)
    _render_json_success_pretty
  end

  def mark_as_viewed
    current_user.recieved_notifications.find_by_id(params[:id]).try(:update_attribute, :viewed, true) ? _render_json_success_pretty : _render_json_error_pretty
  end
end
