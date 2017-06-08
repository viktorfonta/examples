'use strict'
etcApp.factory 'App2VideoService', [
  'App2RequestManager'
  (App2RequestManager) ->
    remove = (video, callback) ->
      url = Routes.v2_video_path(video.id)
      App2RequestManager.delete(url, {}, {authToken: getCurrentUser().auth_token}, callback)

    update = (videos, videoType, callback) ->
      args = {videos: _.map(videos, (video) -> {id: video.id, player_url: video.player_url, video_type: videoType, thumbnail_url: null})}
      url = Routes.v2_videos_path()
      App2RequestManager.post(url, args, null, {authToken: getCurrentUser().auth_token}, callback)

    videos = (callback) ->
      url = Routes.v2_videos_path()
      App2RequestManager.get(url, {authToken: getCurrentUser().auth_token}, callback)

    video = (target, login_status, video_type, callback) ->
      url = Routes.v2_video_path('welcome_video', {target: target, login_status: login_status, video_type: video_type})
      App2RequestManager.get(url, {}, callback)

    banner = (callback) ->
      url = Routes.banner_v2_videos_path()
      App2RequestManager.get(url, {}, callback)

    settings_videos = (callback) ->
      url = Routes.settings_videos_v2_videos_path()
      App2RequestManager.get(url, {authToken: getCurrentUser().auth_token}, callback)

    sample_videos = (callback) ->
      url = Routes.sample_videos_v2_videos_path()
      App2RequestManager.get(url, {}, callback)

    App2VideoService =
      remove: remove
      update: update
      videos: videos
      video: video
      banner: banner
      settingsVideos: settings_videos
      sampleVideos: sample_videos

    App2VideoService
]
