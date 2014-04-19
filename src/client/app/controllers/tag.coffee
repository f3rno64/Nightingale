angular.module("App").controller "TagController", ($scope, $routeParams, TweetService, UserService, $location) ->

  TweetService.getAllTweets (tweets) ->
    console.log tweets
