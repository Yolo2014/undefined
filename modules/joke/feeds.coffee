Promise = require 'bluebird'
Feed = require __basename + "/models/media/feed"

module.exports = (req, res, next) ->
  {limit, offset} = req.query
  Promise.resolve()
  .then findFeed
    limit: limit or 20
    offset: offset or 0
  .then (result) ->
    res.send result
  .catch next

findFeed = (options) -> ->
  {limit, offset} = options
  Feed.find()
  .lean()
  .limit limit
  .skip offset
  .execAsync()