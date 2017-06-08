class AuthenticationsController < APIController
  skip_before_filter :initialize_service
  skip_before_filter :authenticate_user!, only: [:logout, :login, :reset_password, :login_external]
  skip_before_filter :clear_session

  def login
    user = User.find_for_database_authentication(email: params[:username])

    if user && user.valid_password?(params[:password]) && user.active_for_authentication?
      sign_out user
      cookies.delete(user.auth_token)
      user.reset_authentication_token!
      session[:auth_token] = user.auth_token
      cookies[:auth_token] = user.auth_token
      user.update_attribute(:status, true)
      _render_json_success_pretty(auth_key: user.auth_token,
                                  user_id: user.id,
                                  role: user.role,
                                  available_to_chat: user.available_to_chat)
      if user.tutor? && user.teaching_videos.empty?
        Notification.notify(notification_type: 'tutoring_video_pending', recipient: user, entities: [user])
      end
    else
      message = t('errors.invalid_email_password')
      message = user.inactive_message if user && !user.active_for_authentication?

      if user.try(:closed?)
        message = t('devise.failure.reactivate')
        user.send(:generate_confirmation_token!)
        UserMailer.delay.send_reactivate_email(user)
      end

      _render_json_error_pretty(message: message)
    end
  end

  def login_external
    if user = User.find_social_provider(params)
      cookies[:auth_token] = user.auth_token
      session[:auth_token] = user.auth_token
      _render_json_success_pretty(auth_key: user.auth_token,
                                  user_id: user.id,
                                  role: user.role,
                                  available_to_chat: user.available_to_chat
      )
    else
      _render_json_error_pretty(message: 'Can not find user with this email. Please sign up first')
    end
  end

  def logout
    user = current_user || User.find_by_authentication_token(cookies[:auth_token])
    if user
      user.update_attribute(:status, false)
      user.reset_authentication_token!
      sign_out user
      cookies.delete(:auth_token)
      return user.is_admin? ? redirect_to(root_path) : _render_json_success_pretty
    end
    redirect_to(root_path)
  end

  def reset_password
    if user = User.where(email: params[:email]).first
      user.send_reset_password_instructions
      _render_json_success_pretty
    else
      _render_json_error_pretty
    end
  end

end
