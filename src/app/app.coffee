window.App = angular.module "App", ["ngRoute", "ngResource"]

angular.module("App").config ($routeProvider, $locationProvider) ->

  $locationProvider.html5Mode true
  $locationProvider.hashPrefix "!"

  $routeProvider.when "/tag/:tag",
    controller: "Tag"
    templateUrl: "/views/tag"

  $routeProvider.otherwise { redirectTo: "/tag/all" }
