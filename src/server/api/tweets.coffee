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

module.exports = (app) -> new APITweets app
