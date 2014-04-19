angular.module("App").factory "Tag", ($resource) ->
  $resource "/api/v1/tags/:id", id: "@id"
