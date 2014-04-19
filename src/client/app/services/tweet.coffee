# This currently uses localStorage; Needs to be updated to use a persistent
# API in the future...

angular.module("App").service "TweetService", [
  "Tweet"
  "$location"
  (Tweet, $location) ->

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

      save: (tweet, cb, errcb) ->
        cache.setItem tweet

        Tweet.$save().then ->
          cb tweet
        , ->
          errcb()
]
