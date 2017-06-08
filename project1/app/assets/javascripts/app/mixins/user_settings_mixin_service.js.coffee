etcApp.factory('App2UserSettingsMixinService', [
  '$rootScope'
  '$modal'
  'App2UserService'
  'App2ModalService'
  ($rootScope, $modal, App2UserService, App2ModalService) ->

    ($scope, initUserCallback) ->
      $scope.initUserCallback = initUserCallback
      $scope.itemPanels = {}
      $scope.uploading = false

      $scope.loadUser = (callback) ->
        App2UserService.profile(getCurrentUser().id, (result, isOk) ->
          if isResponseSuccess(result, isOk)
            $scope.user = result.user
            $scope.initUserCallback() if $scope.initUserCallback
            callback() if callback
        )
      $scope.loadUser()


      $scope.toggleItemPanel = (e, key) ->
        if $scope.itemPanels[key]
          e.stopPropagation()
          return
        $scope.itemPanels[key] = !$scope.itemPanels[key]

      $scope.closeItem = (target) ->
        $scope.itemPanels[target] = false
        $(".an-item-toggler[data-target='##{target}']").parents('.an-holder-toggler').find(".collapse").collapse('hide')
        return false

      $scope.resetEnterEmail = ->
        $scope.user.reset_email = true

      $scope.uploadPhoto = ->
        $modal.open(
          controller: "App2UserUploadPhotoModalController"
          templateUrl: 'modals/_upload_photo_modal.html'
          resolve:
            user: -> $scope.user
            popupTitle: -> I18n.t('js.messages.change_profile_photo')
        )


])


