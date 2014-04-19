angular.module("App").controller "RootController", ($scope, TweetService, UserService) ->

  $scope.tags = []

  TweetService.getAllTweets (tweets) ->
    $scope.tags = _.uniq _.flatten _.pluck(tweets, "tag")
