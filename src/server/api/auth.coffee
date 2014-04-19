spew = require "spew"
passport = require "passport"
APIBase = require "./base"

class APIAuth extends APIBase

  constructor: (@app) ->
    @registerRoutes()

  ###
  # Register our routes on an express server
  ###
  registerRoutes: ->

    ###
    # Redirect the user to Twitter for authentication. When complete, Twitter
    # will redirect the user back to the application at /auth/twitter/callback
    ###
    @app.get "/auth/twitter", passport.authenticate "twitter"

    ###
    # Twitter will redirect the user to this URL after approval. Finish the
    # authentication process by attempting to obtain an access token. If access
    # was granted, the user will be logged in. Otherwise, auth has failed.
    ###
    @app.get "/auth/twitter/callback", passport.authenticate "twitter",
      successRedirect: "/"
      failureRedirect: "/login"

module.exports = (app) -> new APIAuth app
