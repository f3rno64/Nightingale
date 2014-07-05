mongoose = require "mongoose"
config = require "../config"
OAuth = require("oauth").OAuth

schema = new mongoose.Schema
  owner: { type: mongoose.Schema.Types.ObjectId, ref: "User" }
  content: { type: String, required: true }
  tags: [{ type: String }]
  consumed: { type: Boolean, default: false }

###
# Convert model to API-safe object
#
# @return [Object] apiObject
###
schema.methods.toAPI = ->
  ret = @toObject()
  ret.id = ret._id.toString()
  delete ret._id
  delete ret.__v
  delete ret.version
  ret

###
# Return an API-safe object with ownership information stripped
#
# @return [Object] anonAPIObject
###
schema.methods.toAnonAPI = ->
  ret = @toAPI()
  delete ret.owner
  ret

###
# Consume tweet by tweeting it. This updates our @consumed value!
###
schema.methods.consume = (cb) ->

  oa = new OAuth "https://twitter.com/oauth/request_token",
    "https://twitter.com/oauth/access_token",
    config("twitter_consumer_key"),
    config("twitter_consumer_secret"),
    "1.0A",
    "http://www.nightingale.dev/auth/twitter/callback",
    "HMAC-SHA1"

  oa.post "https://api.twitter.com/1.1/statuses/update.json",
    @owner.token,
    @owner.tokenSecret,
    {
      status: @content
    }, (err, data) =>
      @consumed = true unless err

      cb err, data

mongoose.model "Tweet", schema
