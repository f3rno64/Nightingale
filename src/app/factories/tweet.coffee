angular.module("App").factory "TweetFactory", ($resource) ->
  $resource "/api/v1/tweets/:id", id: "@id"
