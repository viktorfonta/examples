project1RouterConfig = ['$routeSegmentProvider', ($routeSegmentProvider) ->

  $routeSegmentProvider
    .when "/", "landing"
    .when "/404", "landing.404"

    .segment "landing",
      templateUrl: "landing_default.html"
      controller: "App2LandingDefaultController"
    .within()
      .segment "" ,
        templateUrl: "_landing.html"
        controller: "App2HomeController"
        default: true
      .segment "404" ,
        templateUrl: "static/_page_not_found.html"
        controller: "App2ErrorController"
    .up()


    .when '/sample-videos', "main.sample-videos"
    .when '/search', "main.search"

    .segment "main",
      templateUrl: "default.html"
      controller: "App2DefaultController"
    .within()
      .segment "aboutus",
        templateUrl: "static/_aboutus.html"

      .segment "static",
        templateUrl: "static/default.html"
        controller: "App2StaticPageDefaultController"
    .up()

]

project1App.config etcRouterConfig

project1App.config [ 'uiSelectConfig', (uiSelectConfig) ->
  uiSelectConfig.theme = 'bootstrap';
]

project1App.run ['$rootScope', '$location', ($rootScope, $location) ->
  $rootScope.$on '$routeChangeStart', ->
    if userSignedIn() && !$location.path().match(/\/(tutor|student|admin)\/.*/)
      if getCurrentUser().role == 'admin'
        window.location.assign('/admin')
      else
        if $location.path().match(/\/(tutors|group-sessions)\/.*/)
          $location.path("/#{getCurrentUser().role}#{$location.path()}")
        else
          $location.path("/#{getCurrentUser().role}/home")

]
