class APIController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :null_session,
      if: Proc.new { |c| c.request.format =~ %r{application/json} }
  before_filter :clear_session
  before_filter :authenticate_user!
  before_filter :initialize_service
  before_filter :admin_forbidden!
  after_filter :_set_response_headers
  around_filter :set_time_zone

  include ExceptionLogger::ExceptionLoggable

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception do |exception|
      if [ActiveRecord::RecordNotFound,
          ActionController::RoutingError,
          ActionController::UnknownController,
          ActionController::MethodNotAllowed].include?(exception.class)
        render_404
      else
        render_500(exception)
      end
    end
  end

  def find_current_user
    @current_user = User.find_by_authentication_token(cookies[:auth_token]) unless current_user
  end

  def _set_response_headers
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    response.headers['Access-Control-Request-Method'] = '*'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, X-Etc-Auth-Key'
  end

  def _render_json_pretty(json)
    render json: JSON.pretty_generate(json)
  end

  def _render_json_success_pretty(json = {})
    json[:status] = 'OK' unless json[:status]
    _render_json_pretty(json)
  end

  def _render_json_error_pretty(json = {})
    json[:status] = 'ERROR' unless json[:status]
    _render_json_pretty(json)
  end

  def parse_class object
    object.as_json.class
  end

  protected

  def clear_session
    sign_out(current_user) if current_user
  end

  private

  def set_time_zone
    old_time_zone = Time.zone
    Time.zone = browser_timezone if browser_timezone.present?
    yield
  ensure
    Time.zone = old_time_zone
  end

  def browser_timezone
    current_user.update_attribute('time_zone', cookies['browser.timezone']) if current_user &&
        current_user.time_zone != cookies['browser.timezone']
    cookies['browser.timezone']
  end

  def render_404
    render json: {error: 'Page not found'}, status: 404
  end

  def render_500(exception)
    log_exception_ex(exception)
    render json: {error: 'Something went wrong'}, status: 500
  end

  def log_exception_ex(exception)
    Rails.logger.info '*' * 100
    Rails.logger.info "Error: #{exception.class.name} -- #{exception.message.inspect}"
    Rails.logger.info "Backtrace: #{exception.backtrace.join("\n")}"
    Rails.logger.info '*' * 100
    log_exception(exception)
  end

  def admin_forbidden!
    render json: {} if current_user && current_user.admin?
  end
end
