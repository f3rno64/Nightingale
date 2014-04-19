angular.module("App").factory "User", ($resource) ->
  $resource "/api/v1/user"
