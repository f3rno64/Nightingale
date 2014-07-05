angular.module("App").service "TweetService", [
  "Tweet"
  "$rootScope"
  (Tweet, $rootScope) ->

    cache = new ServiceCache

    service =
      getAllTweets: (cb) ->
        Tweet.query (tweets) ->

          cache.clear()
          cache.setMultiple tweets

          cb tweets

      getTweet: (id, cb) ->
        return cb cache.getItem(id) if cache.hasItem(id)

        Tweet.get id: id, (tweet) ->
          cache.setItem tweet
          cb tweet

      deleteTweet: (id, cb) ->
        Tweet.delete id: id, ->
          cache.clearItem id
          $rootScope.$broadcast "refreshTweets"
          cb() if cb

      save: (tweet, cb, errcb) ->
        cache.setItem tweet

        tweet.$save().then ->
          $rootScope.$broadcast "refreshTweets"
          cb tweet if cb
        , ->
          errcb() if errcb

      consumeTweet: (tweet, cb, errcb) ->
        tweet.consumed = true
        cache.setItem tweet

        tweet.$consume().then ->
          $rootScope.$broadcast "refreshTweets"
          cb tweet if cb
        , ->
          errcb() if errcb

]
