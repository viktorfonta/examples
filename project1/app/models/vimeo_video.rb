class VimeoVideo < ActiveRecord::Base
  extend VimeoUploader

  belongs_to :user

  def video_url
    "//player.vimeo.com/video/#{video_id}"
  end
end
