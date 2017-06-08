class TagsController < APIController
  skip_before_filter :initialize_service

  def index
    _render_json_success_pretty(tags: current_user.tags.includes(:topic).as_json(JsonService::TAG_LIST))
  end

  def destroy
    current_user.tags.find(params[:id]).destroy
    _render_json_success_pretty
  end

  def create
    tags = params[:tags] || [params]
    tags.each { |tag| Tag.create_for_user(current_user, tag) }
    _render_json_success_pretty
  end
end