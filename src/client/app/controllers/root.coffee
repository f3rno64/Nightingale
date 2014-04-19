angular.module("App").controller "RootController", ($scope, $rootScope, Tweet, TweetService, UserService, NotificationService) ->

  $scope.tags = []
  $scope.composing = false
  $scope.editing = false
  $scope.notification = NotificationService

  refreshTags = ->
    TweetService.getAllTweets (tweets) ->
      $scope.tags = _.uniq _.flatten _.pluck(tweets, "tags")

  refreshTags()

  $scope.showTweetForm = (editing) ->
    editing = false if editing != true

    $scope.newTweet = {}
    $scope.composing = true
    $scope.editing = editing

  $scope.closeTweetForm = ->
    $scope.composing = false

  $scope.getFormRemainingChars = ->
    if $scope.newTweet and $scope.newTweet.content
      140 - $scope.newTweet.content.length
    else
      140

  $scope.submitTweet = ->
    unless $scope.newTweet.content and $scope.newTweet.content.length > 0
      NotificationService.setNotification "Enter some content!", "orange"
      return

    unless $scope.newTweet.unsplitTags and $scope.newTweet.unsplitTags.length > 0
      NotificationService.setNotification "Enter at least one tag!", "orange"
      return

    NotificationService.setNotification "Saving...", "", false

    if $scope.editing or $scope.newTweet.id
      TweetService.save $scope.newTweet, ->
        NotificationService.setNotification "Saved!", "green"
        $scope.closeTweetForm()
      , ->
        NotificationService.setNotification "There was an error saving ;(", "red"
    else
      tweet = new Tweet $scope.newTweet
      tweet.$save().then ->
        NotificationService.setNotification "Saved!", "green"
        $scope.closeTweetForm()
        $rootScope.$broadcast "refreshTweets"
      , ->
        NotificationService.setNotification "There was an error saving ;(", "red"

  $scope.$on "editTweet", (e, id) ->
    TweetService.getTweet id, (tweet) ->

      $scope.showTweetForm true

      $scope.newTweet = tweet
      $scope.newTweet.unsplitTags = $scope.newTweet.tags.join ", "

  $scope.$on "refreshTweets", -> refreshTags()
