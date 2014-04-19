spew = require "spew"
db = require "mongoose"
async = require "async"
_ = require "lodash"
APIBase = require "./base"

class APITweets extends APIBase

  constructor: (@app) ->
    super model: "Tweet"
    @registerRoutes()

  ###
  # Creates a new ad model with the provided options
  #
  # @param [Object] options
  # @param [ObjectId] owner
  # @return [Campaign] model
  ###
  createNewTweet: (options, owner) ->
    db.model("Tweet")
      owner: owner

  ###
  # Register our routes on an express server
  ###
  registerRoutes: ->

    ###
    # GET /api/v1/tweets
    #   Returns a list of all owned Tweets
    # @response [Array<Object>] Tweets a list of Tweets
    # @example
    #   $.ajax method: "GET",
    #          url: "/api/v1/tweets"
    ###
    @app.get "/api/v1/tweets", @apiLogin, (req, res) =>
      @queryOwner req.user.id, res, (tweets) ->
        return res.json 200, [] if tweets.length == 0

        res.json _.map tweets, (t) -> t.toAnonAPI()

module.exports = (app) -> new APITweets app
