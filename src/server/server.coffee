config = require "./config"
spew = require "spew"
express = require "express"
passport = require "passport"
morgan = require "morgan"
bodyParser = require "body-parser"
cookieParser = require "cookie-parser"
flash = require "connect-flash"
session = require "express-session"

spew.setLogLevel config("loglevel")
spew.init "Starting Nightingale..."

app = express()
app.use express.static "#{__dirname}/../client/"
app.use morgan "dev"
app.use bodyParser()
app.use cookieParser "rRd0udXZRb0HX5iqHUcSBFck4vNhuUkW"

app.set "views", "#{__dirname}/../client/views"
app.set "view options", layout: false

app.use session secret: "EYQn1C4yP04ggfpDpVoMk6IsJcl7kpHS"
app.use flash()
app.use passport.initialize()
app.use passport.session()

app.listen config "port"
spew.init "Server listening on port #{config("port")}"

require("./init") app, ->

  require("./api/auth") app
  require("./api/tweets") app
  require("./api/app_views") app
  require("./api/user") app

  app.get "/*", (req, res) -> res.send 404
  spew.init "Init complete!"
