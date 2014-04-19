angular.module("App").controller "Tag", ($scope, $routeParams, TagService) ->

  TagService.getAllTags (tags) ->
    console.log tags
