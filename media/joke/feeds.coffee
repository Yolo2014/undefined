fs = require 'fs'

_ = require 'underscore'
request = require 'superagent'
Promise = require 'bluebird'

ParseFeeds = require './parse_feeds'

module.exports = (req, res, next) ->

  if req.query.page
    startPage = req.query.page
    endPage = req.query.page
    offset = 0
    limit = 20
  else
    req.query.offset or= 0
    req.query.limit or= 20
    startPage = Math.ceil((parseInt(req.query.offset) + 1) / 20)
    endPage = startPage + (Math.ceil((req.query.limit or 0) / 20) or 1) - 1
    offset = req.query.offset % 20
    limit = parseInt req.query.limit, 10

  getPagePromise = (url, query) ->
    request
    .get url
    .set "User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36"
    .query query
    .endAsync()
    .then (page) ->
      page

  getPagePromises = _.map [startPage..endPage], (page) ->
    url = "http://www.walxh.com/pc/late"

    getPagePromise url, req.query
    .then (page) ->
      return throw new Error "ooops, no content!" if !page or !page.text
      ParseFeeds page.text

  Promise.all getPagePromises
  .then (result) ->
    res.send result[0]
  .catch next
