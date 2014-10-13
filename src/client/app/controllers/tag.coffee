angular.module("App").controller "TagController", ($scope, $routeParams, TweetService, UserService, $location, NotificationService) ->

  capitalize = (s) ->
    "#{s[0].toUpperCase()}#{s[1...].toLowerCase()}"

  $scope.tweets = []
  $scope.tag = capitalize $routeParams.tag

  refreshTweets = ->
    TweetService.getAllTweets (tweets) ->

      if $routeParams.tag.toLowerCase() == "all"
        $scope.tweets = tweets
      else
        $scope.tweets = _.filter tweets, (tweet) ->
          _.contains tweet.tags, $routeParams.tag

  refreshTweets()

  $scope.consumeTweet = (id) ->
    return unless tweet = _.find $scope.tweets, (t) -> t.id == id
    return if tweet.consumed

    if confirm "Are you sure?"
      NotificationService.setNotification "Tweeting...", "", false
      TweetService.consumeTweet tweet, ->
        NotificationService.setNotification "Tweet sent!", "green"

      # We get an array of errors, but only display the first one
      , (errors) ->
        alert "Error: #{errors[0].message}"

        NotificationService.setNotification errors[0].message, "red"

  $scope.editTweet = (id) ->
    $scope.$emit "editTweet", id

  $scope.deleteTweet = (id) ->
    if confirm "Are you sure?"
      TweetService.deleteTweet id, ->

        $scope.tweets = _.remove $scope.tweets, (t) -> t.id == id

  $scope.$on "refreshTweets", -> refreshTweets()
