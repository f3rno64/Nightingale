spew = require "spew"
db = require "mongoose"
async = require "async"
_ = require "lodash"
APIBase = require "./base"
S = require "string"

class APITweets extends APIBase

  constructor: (@app) ->
    super
      model: "Tweet"
      populate: ["owner"]

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

    @app.get "/api/v1/tweets", @isLoggedIn, (req, res) =>
      @queryOwner req.user.id, res, (tweets) ->
        return res.json 200, [] if tweets.length == 0

        res.json _.map tweets, (t) -> t.toAnonAPI()

    @app.post "/api/v1/tweets", @isLoggedIn, (req, res) =>
      return res.send 400 unless req.body.content
      return res.send 400 unless req.body.tags or req.body.unsplitTags

      unproccessedTags = req.body.unsplitTags.split(",") or req.body.tags
      tags = _.map unproccessedTags, (tag) -> S(tag.replace(/\W/g, "")).trim().s

      tweet = db.model("Tweet")
        owner: req.user.id
        content: req.body.content
        tags: tags

      tweet.save (err) ->
        if err
          spew.error err
          return res.send 500

        res.json tweet.toAnonAPI()

    @app.post "/api/v1/tweets/:id", @isLoggedIn, (req, res) =>

      # Consume tweet
      if req.query.consume

        @queryId req.params.id, res, (tweet) ->
          return res.send 404 unless tweet
          return res.send 400 if tweet.consumed

          tweet.consume (err, data) ->
            if err
              spew.error JSON.stringify err
              return res.json 500, JSON.parse(err.data).errors

            tweet.consumed_date = Date.now()

            tweet.save (err) ->
              if err
                spew.error err
                return res.send 500

              res.json tweet.toAnonAPI()

      # Save modified tweet
      else
        return res.send 400 unless req.body.content
        return res.send 400 unless req.body.tags or req.body.unsplitTags

        unproccessedTags = req.body.unsplitTags?.split(",") or req.body.tags
        tags = _.map unproccessedTags, (tag) ->
          S(tag.replace(/\W/g, "")).trim().s

        @queryId req.params.id, res, (tweet) ->
          return res.send 404 unless tweet

          tweet.tags = tags
          tweet.content = req.body.content

          tweet.save (err) ->
            if err
              spew.error err
              return res.send 500

            res.json tweet.toAnonAPI()

    @app.delete "/api/v1/tweets/:id", @isLoggedIn, (req, res) =>
      @queryId req.params.id, res, (tweet) ->
        return res.send 404 unless tweet

        tweet.remove (err) ->
          if err
            spew.error err
            return res.send 500

          res.send 200

module.exports = (app) -> new APITweets app
