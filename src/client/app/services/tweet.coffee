angular.module("App").service "TweetService", [
  "Tweet"
  "$rootScope"
  (Tweet, $rootScope) ->

    cache = new ServiceCache

    # Generate a date string
    processTweet = (tweet) ->
      return tweet unless tweet.consumed_date

      date = new Date tweet.consumed_date
      tweet.consumed_date_str = date.toLocaleDateString()
      tweet

    service =
      getAllTweets: (cb) ->
        Tweet.query (tweets) ->

          processTweet tweet for tweet in tweets

          cache.clear()
          cache.setMultiple tweets

          cb tweets

      getTweet: (id, cb) ->
        return cb cache.getItem(id) if cache.hasItem(id)

        Tweet.get id: id, (tweet) ->
          processTweet tweet

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
        tweet.$consume().then ->

          tweet.consumed = true
          cache.setItem tweet

          $rootScope.$broadcast "refreshTweets"
          cb tweet if cb

        , (res) ->
          errcb(res.data) if errcb

]
