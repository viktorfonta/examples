class WebexesController < APIController
  skip_before_filter :initialize_service

  def create
    job = WebexHost.delay(queue: 'webex', priority: -10).send("create_#{params[:type]}", current_user, webex_params)
    _render_json_success_pretty(wait_for_host: true, session_id: webex_params[:session_id].to_i, session_type: params[:type], job_id: job.id)
  rescue
    LoggedException.create_from_exception(self, $!, {})
    _render_json_error_pretty(message: $!.is_a?(WebexHost::WebexError) ? $!.to_s : I18n.t('js.messages.something_went_wrong'))
  end

  def join
    result = WebexHost.send("join_#{params[:type]}", current_user, webex_params)
    _render_json_success_pretty(result)
  rescue
    LoggedException.create_from_exception(self, $!, {})
    _render_json_error_pretty(message: $!.is_a?(WebexHost::WebexError) ? $!.to_s : I18n.t('js.messages.something_went_wrong'))
  end

  def rejoin
    parameters = webex_params
    webex_host = WebexHost.in_progress.where(target_id: parameters[:session_id], target_type: params[:type]).first
    if current_user.is_student? || webex_host && webex_host.webex_session_exists?(current_user)
      result = WebexHost.send("goto_#{params[:type]}", current_user, parameters)
    else
      job = WebexHost.delay(queue: 'webex', priority: -10).recreate(params[:type], current_user, parameters, webex_host)
      result = {wait_for_host: true, session_id: parameters[:session_id].to_i, session_type: params[:type], job_id: job.id}
    end
    _render_json_success_pretty(result)
  rescue
    LoggedException.create_from_exception(self, $!, {})
    _render_json_error_pretty(message: $!.is_a?(WebexHost::WebexError) ? $!.to_s : I18n.t('js.messages.something_went_wrong'))
  end

  def delayed
    if params[:job_id] && DelayedJob.exists?(params[:job_id])
      result = {wait_for_host: true, session_id: params[:session_id].to_i, session_type: params[:type], job_id: params[:job_id].to_i}
    else
      webex_host = WebexHost::WebexHost.in_progress.where(target_id: params[:session_id], target_type: params[:type]).first
      WebexHost.check_owner(current_user, webex_host)
      result = { session_id: webex_host.target_id,
                 session_type: webex_host.target_type.downcase,
                 join_url: webex_host.host_url,
                 rejoin: params[:rejoin] }
    end
    _render_json_success_pretty(result)
  rescue
    LoggedException.create_from_exception(self, $!, {})
    _render_json_error_pretty(message: $!.is_a?(WebexHost::WebexError) ? $!.to_s : I18n.t('js.messages.something_went_wrong'), session_id: params[:session_id].to_i, session_type: params[:type])
  end

  private

  def webex_params
    params.permit(:session_id, :auth_token)
  end
end
