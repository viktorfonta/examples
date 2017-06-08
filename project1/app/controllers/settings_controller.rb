class SettingsController < APIController
  skip_before_filter :initialize_service
  skip_before_filter :authenticate_user!, only: [:var, :vars]

  def var
    _render_json_success_pretty(setting: SystemSetting.where(var: params[:var]).first.as_json(JsonService::SETTING_LIST))
  end

  def vars
    _render_json_success_pretty(settings: SystemSetting.where(["var IN (?)", params[:vars]]).as_json(JsonService::SETTING_LIST))
  end

end
