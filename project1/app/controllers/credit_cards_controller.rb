class CreditCardsController < APIController
  skip_before_filter :initialize_service

  def create
    unless (res = current_user.update_credit_card(params))[:errors]
      _render_json_success_pretty(user: current_user.reload.as_json(JsonService.send("#{current_user.role}_info", current_user)))
    else
      _render_json_error_pretty(res)
    end
  end

  def destroy
    current_user.remove_credit_card ? _render_json_success_pretty : _render_json_error_pretty
  end

  def show
    if credit_card = current_user.credit_card
      _render_json_success_pretty credit_card: credit_card
    else
      _render_json_error_pretty
    end
  end

end
