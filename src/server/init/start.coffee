config = require "../config"
spew = require "spew"
mongoose = require "mongoose"
fs = require "fs"
passport = require "passport"
TwitterStrategy = require("passport-twitter").Strategy

module.exports = (express, cb) ->

  ## Passport setup
  passport.use new TwitterStrategy
    consumerKey: config "twitter_consumer_key"
    consumerSecret: config "twitter_consumer_secret"
    callbackURL: "http://www.nightingale.dev/auth/twitter/callback"
  , (token, tokenSecret, profile, done) ->

    mongoose.model("User").findOne twitterId: Number(profile.id), (err, user) ->
      if err
        spew.error err
        return done err

      unless user
        user = mongoose.model("User")
          twitterId: Number profile.id
          username: profile.username
          displayName: profile.displayName

      user.tokenSecret = tokenSecret
      user.token = token
      user.rawProfile = profile._raw

      user.save (err) ->
        if err
          spew.error err
          return done err

        signedup = new Date(Date.parse(user._id.getTimestamp())).getTime() / 1000
        user = user.toAPI()
        user.signedup = signedup

        done null, user

  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    mongoose.model("User").findById id, (err, user) ->
      return done err if err
      return done null, false, message: "User not found" unless user

      signedup = new Date(Date.parse(user._id.getTimestamp())).getTime() / 1000
      user = user.toAPI()
      user.signedup = signedup

      done null, user

  ## Connect to MongoDB
  con = "mongodb://#{config("mongo_user")}:#{config("mongo_pass")}"
  con += "@#{config("mongo_host")}:#{config("mongo_port")}"
  con += "/#{config("mongo_db")}"

  dbConnection = mongoose.connect con, (err) ->
    if err
      spew.critical "Error connecting to database [#{err}]"
      spew.critical "Using connection: #{con}"
      spew.critical "Environment: #{config("NODE_ENV")}"
    else
      spew.init "Connected to MongoDB [#{config("NODE_ENV")}]"

    # Setup db models
    modelPath = "#{__dirname}/../models"
    fs.readdirSync(modelPath).forEach (file) ->
      if ~file.indexOf ".coffee" then require "#{modelPath}/#{file}"

    cb()
