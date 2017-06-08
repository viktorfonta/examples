"use strict"
etcApp.controller "App2DefaultController", [
  "$rootScope"
  "$scope"
  "$location"
  '$timeout'
  'App2SignupModalMixinService'
  ($rootScope, $scope, $location, $timeout, App2SignupModalMixinService) ->
    angular.extend($scope, App2SignupModalMixinService($scope))

    $rootScope.globalBodyClass = ""
    $rootScope.currentYear = moment().year()

    $scope.isActive = (viewLocations) ->
      _.contains(viewLocations, $location.path())

    $scope.isActiveNav = false

    $scope.toggleNav = ->
      $scope.isActiveNav = !$scope.isActiveNav

    $scope.hideNav = ->
      $scope.isActiveNav = false

]
