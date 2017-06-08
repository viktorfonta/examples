class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  prepend_before_filter :find_current_user
  around_filter :set_time_zone
  before_action :load_ogs

  def index
  end

  def current_admin_user
    current_user
  end

  def authenticate_admin_user!
    return redirect_to(root_path) unless current_user.try(:admin?)
  end

  def mail_tracker
    redirect_to(params[:url] || root_path)
  end

  def admin_access_denied(exception)
    redirect_to admin_root_path, flash: { error: exception.message }
  end

  private

  def find_current_user
    token_and_options = ActionController::HttpAuthentication::Token.token_and_options(request)
    auth_token = (token_and_options && token_and_options.first) || params[:auth_token]
    if auth_token && !request.xhr?
      sign_out(current_user)
      cookies[:auth_token] = auth_token
    end
    @current_user = User.find_by_authentication_token cookies[:auth_token]
  end

  def set_time_zone
    old_time_zone = Time.zone
    Time.zone = browser_timezone if browser_timezone.present?
    yield
  ensure
    Time.zone = old_time_zone
  end

  def browser_timezone
    cookies["browser.timezone"]
  end

  def paypal_service
    @paypal_service ||= PaypalService.new(current_user)
  end

  def load_ogs
    @og_title = 'Project 1'
    @og_description = 'Example'
    @og_image = ActionController::Base.helpers.asset_url('fb_meta.jpg')
    @og_url = "#{request.protocol}#{request.host_with_port}/"
  end
end
