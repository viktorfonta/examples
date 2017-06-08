'use strict'
etcApp.directive 'project1UserStatus', [
  ->
    {
    restrict: 'E'
    scope:
      user: "="
    template: '<span class="an-tutor-online" ng-if="user.status && user.chat_on"><span title="Online" class="an-online"></span></span>'
    controller: [
      '$scope'
      ($scope) ->
        $scope.$on 'update.chat_setting', (e, data) ->
          if $scope.user.id == data.user.id
            $scope.user = _.extend($scope.user, {status: data.user.status, chat_on: data.user.chat_on})
            $scope.$apply()

    ]
    }
]

