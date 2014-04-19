mongoose = require "mongoose"

schema = new mongoose.Schema

  twitterId: { type: Number, required: true }
  username: { type: String, required: true }
  displayName: { type: String, required: true }

  rawProfile: { type: String, required: true }

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
  ret

mongoose.model "User", schema
