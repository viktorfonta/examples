etcApp.factory('App2UploadPhotoMixinService', [
  '$rootScope'
  '$modal'
  '$location'
  'App2ModalService'
  'App2FileService'
  ($rootScope, $modal, $location, App2ModalService, App2FileService) ->
    ($scope) ->

      $scope.fileSelect = (files) ->
        file = files[0]
        return unless file
        if file.type.match(/image/)
          $scope.close()
          $modal.open(
            controller: "App2CropImageModalController",
            templateUrl: "modals/_crop_image_modal.html",
            resolve:
              file: ->
                file
              apply_callback: ->
                $scope.uploadImage

          )
        else
          App2ModalService.alert({title: I18n.t('js.messages.upload_fail'), \
            content: I18n.t('js.messages.unsupported_image_format')})

      $scope.uploadImage = (croppedImage, file, closeCallback) ->
        data = _.extend({file: croppedImage, filename: file.name }, $scope.default_params)
        $rootScope.$broadcast('app2.on.file.uploading.state.changed', true)
        App2FileService.create(data, (result, isOk) ->
          if isResponseSuccess(result, isOk)
            if $scope.default_params
              $scope.user.profile_photo = result.file.public_url
              $scope.user.avatar_etc_file_id = result.file.id
              $rootScope.$broadcast('app2.user.changed', $scope.user)
            else
              $scope.session.cover_etc_file = result.file
          else
            App2ModalService.alert({title: I18n.t('js.messages.upload_fail'), \
              content: I18n.t('js.messages.upload_fail')})
          closeCallback()
        )


])
