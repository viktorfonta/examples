$(function () {
  moment.locale("en-US");
  checkCurrentUser();
  jQuery.validator.addMethod("pattern", function (value, element, param) {
    return this.optional(element) || param.test(value);
  }, "Invalid format.");
});
