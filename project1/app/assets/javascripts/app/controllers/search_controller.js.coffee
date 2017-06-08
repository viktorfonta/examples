"use strict"
etcApp.controller "App2SearchController", [
  "$scope"
  "$rootScope"
  "$timeout"
  "$routeParams"
  "$location"
  "App2SearchService"
  'App2TopicPlaceholderMixinService'
  ($scope, $rootScope, $timeout, $routeParams, $location, App2SearchService, App2TopicPlaceholderMixinService) ->
    angular.extend($scope, App2TopicPlaceholderMixinService($scope))

    $scope.querySearch = {term: $routeParams.term || "", show: $routeParams.show}
    $scope.sessionsLength = null
    $scope.tutorsLength = null
    $scope.loader = false
    $scope.suggestions = []
    $scope.suggestionSelected = false
    $scope.suggestionsNotFound = false
    $scope.hideSearchTitle = false
    $scope.showHelpText = true

    $timeout(->
      $scope.typeahead = $('.an-text-field').typeahead(
        source: []
        minLength: 0
        matcher: (item) ->
          item
        highlighter: (item) ->
          html = $("<div></div>")
          query = $scope.querySearch.term
          r = new RegExp(query.replace(" ", "|"), "i")
          query = item.match(r)
          return $("<div></div>").append(html.text(item).addClass('related-results')).html() if item == $scope.relatedStartsFrom
          return html.text(item).html() if !query || query[0].length == 0
          query = query[0]
          i = item.toLowerCase().indexOf(query.toLowerCase())
          len = query.length
          while (i > -1)
            leftPart = item.substr(0, i)
            middlePart = item.substr(i, len)
            rightPart = item.substr(i + len)
            strong = $('<strong></strong>').text(middlePart)
            html.append(document.createTextNode(leftPart)).append(strong)
            item = rightPart
            i = item.toLowerCase().indexOf(query.toLowerCase())
          html.append(document.createTextNode(item)).html()

        updater: (item) ->
          $scope.querySearch.queryTerm = _.find($scope.suggestions, (suggest) ->
            $scope.suggest_topic = suggest.topic_title
            item == suggest.display_text
          ).raw_text
          $scope.topic_title = $scope.suggest_topic.split(' ')[0].toLowerCase()
          $scope.suggestionSelected = true
          $scope.querySearch.term = item
          $scope.search()
          item
      )

      $('.an-text-field').on('typeahead:opened', (ev) ->
        $scope.suggestionsFound = true
        $scope.$apply()
      )

      $('.an-text-field').on('typeahead:closed', (ev) ->
        $scope.suggestionsFound = false
        $scope.suggestions = []
        $scope.$apply()
      )

    , 500
    )

    $scope.clearStates = (clearTerm = false) ->
      $scope.querySearch.term = "" if clearTerm
      $scope.suggestionsFound = false
      $scope.suggestionsNotFound = false
      $scope.searchSuccess = false
      $scope.startSearchTimeout = null

    $scope.clearStates()

    updateTypeahead = (array) ->
      $scope.typeahead.data('typeahead').source = array
      $('.an-text-field').trigger("keyup")

    $scope.searchSuggestions = ->
      $scope.clearStates()
      $scope.loader = true
      updateTypeahead([])

      App2SearchService.suggestions($scope.querySearch.term, (data, isOk) ->
        return if !isOk
        $scope.loader = false
        $scope.suggestions = data.results
        $scope.suggestionsNotFound = ($scope.suggestions.length == 0)
        $scope.suggestionsFound = !$scope.suggestionsNotFound
        updateTypeahead(_.map($scope.suggestions, (item) ->
          if item.result_group == 'related'
            $scope.relatedStartsFrom = item.display_text
          item.display_text
        ))
      )

    $scope.search = ->
      $scope.clearStates()
      $scope.loader = true
      App2SearchService.liveCounts($scope.queryTerm(), (data, isOk) ->
        return if !isOk
        $scope.loader = false
        $scope.searchSuccess = true
        $scope.tutorsLength = data.total_tutors
        $scope.sessionsLength = data.total_sessions
        path = if data.total_sessions then 'group-sessions' else 'tutors'
        $location.path(path).search({term: $scope.queryTerm()})
      )

    $scope.queryTerm = ->
      $scope.querySearch.queryTerm || $scope.querySearch.term

    $scope.searchInputChanged = ->
      if $scope.suggestionSelected
        $scope.suggestionSelected = false
        return

      $scope.querySearch.queryTerm = null
      if $scope.startSearchTimeout
        $timeout.cancel($scope.startSearchTimeout)
      $scope.startSearchTimeout = $timeout(->
        $scope.searchSuggestions()
      , 200)

    $scope.searchInputFocus = ->
      $scope.hideSearchTitle = true
      $scope.showHelpText = true
      $scope.searchSuggestions() if $scope.suggestions.length == 0 && !$scope.loader

    $scope.search() if $routeParams.term

]
