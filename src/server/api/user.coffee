spew = require "spew"
async = require "async"
db = require "mongoose"
config = require "../config"
APIBase = require "./base"
passport = require "passport"

class APIUsers extends APIBase

  constructor: (@app) ->
    super model: "User"
    @registerRoutes()

  registerRoutes: ->

    ###
    # GET /api/v1/user
    #   Retrieves the user represented by the cookies on the request.
    # @example
    #   $.ajax method: "GET",
    #          url: "/api/v1/user"
    ###
    @app.get "/api/v1/user", @apiLogin, (req, res) =>
      @queryId req.user.id, res, (user) ->
        return res.send 404 unless user

        res.json user.toAPI()

module.exports = (app) -> new APIUsers app
