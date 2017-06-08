class SearchesController < APIController
  skip_before_filter :authenticate_user!, except: :tutors
  skip_before_filter :initialize_service

  def live_counts
    _render_json_success_pretty({total_sessions: Seminar.search(params[:query], nil, nil).count,
                                 total_tutors: User.tutor_search(params[:query], nil, nil).count})
  end

  def suggestions
    _render_json_success_pretty(results: UniversalSearch::Suggester.new.search(params[:query]))
  end

  def universities
    render json: AdvancedSearchService.new(:university).search(params[:query]).take(20).to_json
  end

  def subjects
    render json: SubTopic.where("title LIKE ?", "%#{params[:query]}%")
  end

  def tutors
    tutors = Tutor.active.where("name LIKE ?", "%#{params[:query]}%").limit(100).includes(:avatar_etc_file).select{|tutor| !current_user.has_direct_scheduler_session(tutor)}
    render json: tutors.take(10).as_json(JsonService::SIMPLE_USER_INFO)
  end

  def local_courses
    sub_topic_id = params[:sub_topic_id].present? ? (params[:sub_topic_id].to_i.zero? ? SubTopic.where(topic_id: params[:topic_id], other: true).first.id : params[:sub_topic_id]) : nil
    local_courses = LocalCourse.search_course(params[:university_id], params[:topic_id], sub_topic_id, params[:query])
    local_courses = local_courses.search_with_sub_sub_topic(params[:sub_sub_topic_title]) if params[:sub_sub_topic_title].present?
    render json: local_courses.to_a.uniq{|course| course.name}.as_json
  end

end
