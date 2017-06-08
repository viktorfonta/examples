"use strict"
etcApp.controller "App2ErrorController", [
  "$rootScope"
  "$scope"
  '$location'
  ($rootScope, $scope, $location) ->
    $location.path("/#{getCurrentUser().role}/404") if userSignedIn()

    $scope.helpPath =
      if userSignedIn() then "/#{getCurrentUser().role}/help" else "/faq"

    $scope.goBackPath = ->
      if userSignedIn() then javascript:history.go(-2) else javascript:history.go(-1)
]

