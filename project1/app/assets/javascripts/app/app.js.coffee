"use strict"
#
#  Main module
#
@etcApp = angular.module("etcApp", [
  'ngRoute'
  'ngFacebook'
  'angular-flash.service'
  'angular-flash.flash-alert-directive'
  'route-segment'
  'view-segment'
  'ui.select'
  'validator'
  'bootstrapLightbox'
  'validator.rules'
  'infinite-scroll'
  'templates'
  'ui.bootstrap'
  'ngResource'
  'angular.filter'
  'angularFileUpload'
  'angularMoment'
  'ngCookies'
  'ngSanitize'
  'ngImgCrop'
  'angucomplete-alt'
  'ngTagsInput'
  'ui.select'
  'ui-rangeSlider'
  'angular-progress-arc'
  'slickCarousel'
  'NgSwitchery'
])

#"fbphotoselector"
#"truncate"
#  'etcAppFilters'
#  'siyfion.sfTypeahead'
#  'jsTag'
#  'reviews'
#  'cgPrompt'
#  'duScroll'
#  'searchTokenInput'

#
#  Start config and run app
#
etcApp.run ['$rootScope', 'App2RequestManager', '$timeout', '$route', '$location', "FB_API_KEY",
  ($rootScope, App2RequestManager, $timeout, $route, $location, FB_API_KEY) ->
    $rootScope.Configuration =
      baseUrl: "/v1"
      startBaseUrl: "/v2"
    $.cookie "browser.timezone", jstz.determine().name(), {expires: 365, path: '/', domain: ".#{App2RequestManager.domain}"}

    $rootScope.$on '$locationChangeStart', (e, next, current) ->
      $rootScope.previousPageUrl = current

    return
]
