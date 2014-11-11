mongoose = require 'mongoose'
db = require __basename + '/connections/mongo/joke'
# mongoose.set "debug", true
ObjectId = mongoose.Schema.Types.ObjectId

schema = new mongoose.Schema
  _id:
    type: Number
    index: true
  title: String
  content: String
  image: String
  created_at:
    type: Date
    default: Date.now
  update_at:
    type: Date
    default: Date.now
  like: Number
  dislike: Number
  user:
    id:
      type: Number
      index: true
    screen_name: String
    avatar: String

module.exports = db.model 'joke_feed', schema
