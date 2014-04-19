angular.module("App").controller "TagController", ($scope, $routeParams, TweetService, UserService, $location) ->

  # Redirect to account page if no user is logged in
  unless UserService.loggedIn()
    return $location.path "/account"

  TweetService.getAllTweets (tweets) ->
    console.log tweets
