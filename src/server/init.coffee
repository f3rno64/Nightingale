module.exports = (express, cb) ->
  require("./init/start") express, ->
    cb()
