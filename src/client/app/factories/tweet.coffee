angular.module("App").factory "Tweet", ($resource) ->
  $resource "/api/v1/tweets/:id", id: "@id"
