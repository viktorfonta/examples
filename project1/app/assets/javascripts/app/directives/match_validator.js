etcApp.directive('matchValidator', [function() {
    return {
        require: 'ngModel',
        link: function(scope, elm, attr, ctrl) {
            var pwdWidget = elm.inheritedData('$formController')[attr.matchValidator];

            ctrl.$parsers.push(function(value) {
                if (value === pwdWidget.$viewValue) {
                    ctrl.$setValidity('match', true);
                    return value;
                }

                if (value && pwdWidget.$viewValue) {
                    ctrl.$setValidity('match', false);
                }

            });

            pwdWidget.$parsers.push(function(value) {
                if (value && ctrl.$viewValue) {
                    ctrl.$setValidity('match', value === ctrl.$viewValue);
                }
                return value;
            });
        }
    };
}])