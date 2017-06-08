$(document).on 'click', "form.help_video input[type='submit'], form.cms_content input[type='submit']", (e) ->
  e.preventDefault()
  $(@).prop('disabled', true)
  file = $('#video_upload')[0].files[0]
  if file
    $('#video_upload').prop('disabled', true)
    $('form .messages').text('Please wait, video is uploading...')
    token = $('#admin_token').val()
    $.ajax({
      url: "/v2/vimeo_videos/streaming_upload_ticket?auth_token=#{token}"
      type: 'GET'
      success: (response) ->
        ticketData = response.ticket
        upload(file, ticketData).then ->
          $.ajax({
            url: "/v2/vimeo_videos/complete_video_streaming?auth_token=#{token}"
            data: { complete_uri: ticketData.complete_uri, name: file.name }
            type: 'POST'
          }).success((response) ->
            if response.vimeo_video.video_url
              $('#video_player_url').val(response.vimeo_video.video_url)
              $('form.help_video, form.cms_content').submit()
          )
    })
  else
    $('form.help_video, form.cms_content').submit()

upload = (file, ticketData) ->
  deffered = $.Deferred()
  fileReader = new FileReader()
  fileReader.readAsArrayBuffer(file)
  fileReader.onloadend = (e) ->
    $.ajax({
      withCredentials: false
      url: ticketData.upload_link_secure
      type: 'PUT'
      headers: { 'Content-Type': 'multipart/form-data' }
      data: e.target.result
      cache: false
      processData: false
      crossDomain: true
    }).success((data, status, headers, config) ->
      deffered.resolve(data)
    )
  deffered.promise()
