class Video < ActiveRecord::Base
  belongs_to :video_owner, polymorphic: true

  before_save :fetch_metadata
  after_initialize :check_thumbnail
  after_destroy :check_tutor_teaching_videos

  VIDEO_JSON = [:id, :title, :thumbnail_url, :player_url]

  TUTOR_VIDEO_TYPES =  {
      teaching: 'teaching',
      intro: 'intro'
  }

  private
  def check_thumbnail
    return if thumbnail_url && thumbnail_url.split('/').last != 'default_200x150' && thumbnail_url.split('/').last != 'default_640'
    fetch_metadata && save
  end

  def fetch_metadata
    return unless player_url
    id_vimeo = player_url.split("/").last
    response = HTTParty.get("https://vimeo.com/api/v2/video/#{id_vimeo}.json").parsed_response.first

    if response['title'].present?
      self.title = response['title']
      self.thumbnail_url =
        if self.video_owner_type == 'CmsContent' || ( self.video_owner.try(:video_type) == 'sample_tutoring' && !self.video_owner.try(:login_status) )
          response['thumbnail_large'].to_s
        else
          response['thumbnail_medium'].to_s
        end
      self.thumbnail_url.gsub!(/^(https|http):/, '')
      self.duration_seconds = response['duration']
    end
  end

  def check_tutor_teaching_videos
    return unless self.tutor_video_type == 'teaching'
    self.video_owner.update_attributes(teaching_video_deleted_at: Time.now.utc) if self.video_owner.teaching_videos.empty?
  end
end
