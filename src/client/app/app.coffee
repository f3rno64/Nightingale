window.App = angular.module "App", ["ngRoute", "ngResource"]

angular.module("App").config ($routeProvider, $locationProvider) ->

  $locationProvider.html5Mode true
  $locationProvider.hashPrefix "!"

  $routeProvider.when "/tag/:tag",
    controller: "TagController"
    templateUrl: "/views/tag"

  $routeProvider.when "/account",
    controller: "AccountController"
    templateUrl: "/views/account"

  $routeProvider.otherwise { redirectTo: "/tag/all" }
