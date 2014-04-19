mongoose = require "mongoose"

schema = new mongoose.Schema
  owner: { type: mongoose.Schema.Types.ObjectId, ref: "User" }
  content: { type: String, required: true }
  tags: [{ type: String }]

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

mongoose.model "Tweet", schema
