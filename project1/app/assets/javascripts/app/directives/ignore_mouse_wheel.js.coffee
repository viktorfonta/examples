'use strict'
etcApp.directive 'ignoreMouseWheel', [
  '$rootScope'
  '$timeout'
  ($rootScope, $timeout) ->
    {
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.bind(
        'mousewheel'
        (event) ->
          element.blur()
          $timeout(->
            element.focus()
          , 10)
      )
    }
]