"use strict"
etcApp.controller "App2AuthorizationDefaultController", [
  "$scope"
  'App2PrivacyTermsModalMixinService'
  'App2EnvironmentMixinService'
  ($scope, App2PrivacyTermsModalMixinService, App2EnvironmentMixinService) ->
    angular.extend($scope, App2PrivacyTermsModalMixinService($scope))
    angular.extend($scope, App2EnvironmentMixinService($scope))


]
