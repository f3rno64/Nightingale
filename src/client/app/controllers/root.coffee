angular.module("App").controller "RootController", ($scope, TweetService, UserService) ->

  $scope.loggedIn = UserService.loggedIn()
  $scope.tags = []

  if UserService.loggedIn()
    TweetService.getAllTweets (tweets) ->
      $scope.tags = _.uniq _.flatten _.pluck(tweets, "tag")
