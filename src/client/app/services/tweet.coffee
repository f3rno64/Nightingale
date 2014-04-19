# This currently uses localStorage; Needs to be updated to use a persistent
# API in the future...

angular.module("App").service "TweetService", [
  "UserService"
  "$location"
  (UserService, $location) ->

    # Do nothing if no user is logged in
    return unless UserService.loggedIn()

    owner = UserService.getUser().handle

    # Some temporary helpers
    queryData = (query) ->
      query ||= ""
      localStorage.getItem "data.#{owner}#{query}"
    setData = (query, data) ->
      query ||= ""
      localStorage.setItem "data.#{owner}#{query}", data

    cache = new ServiceCache "id"

    service =
      getAllTweets: (cb) ->

        tweets = queryData().tweets

        cache.clear()
        cache.setMultiple tweets

        cb tweets

      getTweet: (id, cb) ->
        return cb cache.getItem(id) if cache.hasItem(id)

        tweets = queryData().tweets
        tweet = _.find tweets, (t) -> t.id == id

        cache.setItem tweet
        cb tweet if cb
        tweet

      save: (tweet) ->
        cache.setItem tweet

        data = queryData()
        tweetIndex = _.findIndex data.tweets, (t) -> t.id == id
        data.tweets[tweetIndex] = tweet

        setData "", data
]
