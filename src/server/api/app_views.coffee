spew = require "spew"
routes = require "../views.json"
config = require "../config"
crypto = require "crypto"
passport = require "passport"
APIBase = require "./base"

class APIAppViews extends APIBase

  constructor: (@app) ->
    @registerRoutes()

  registerRoutes: ->

    # Serve layout to each path
    for p in routes.views
      @app.get p, @isLoggedIn, (req, res) ->

        viewData = {}
        viewData.user = req.user
        viewData.mode = config "NODE_ENV"

        res.render "app.jade", viewData, (err, html) ->
          if err
            spew.error err
            return res.send 500

          res.send html

    @app.get "/login", (req, res) ->
      if req.user != undefined and req.user.id != undefined
        res.redirect "/"
      else
        res.render "login.jade"

    @app.get "/logout", (req, res) ->
      req.logout()
      res.redirect "/login"

    @app.get "/views/:view", @isLoggedIn, (req, res) ->

      if req.params.view.indexOf(":") != -1
        req.params.view = req.params.view.split(":").join "/"

      if req.params.view.indexOf("..") != -1
        req.params.view = req.params.view.split("..").join ""

      viewData = {}
      viewData.user = req.user
      viewData.mode = config "NODE_ENV"

      res.render "app/#{req.params.view}.jade", viewData

module.exports = (app) -> new APIAppViews app
