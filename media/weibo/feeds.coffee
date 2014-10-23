fs = require 'fs'

_ = require 'underscore'
config = require 'config'
request = require 'superagent'
Promise = require 'bluebird'

Cookies = require './cookies'
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

  getPagePromise = (url, query, cookies) ->
    request
    .get url
    .set "Cookie", cookies
    .set "User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36"
    .query query
    .endAsync()
    .then (page) ->
      fs.writeFile "logs/weibo_search_result_#{new Date().valueOf()}.log", page.text if req.query.debug

      if jump_url = page?.text?.match /<meta http\-equiv=\"refresh\" content=\".*?\&\#39\;(.*)\&\#39\;"/
        getPagePromise jump_url?[1], query, cookies
        return null
      else
        page

  getPagePromises = _.map [startPage..endPage], (page) ->
    Cookies.getCookieStr()
    .then (cookies) ->
      url = "http://s.weibo.com/weibo/#{encodeURIComponent(req.query.keyword)}&xsort=time&page=#{page}"
      query = nodup: 1

      if req.query.since and req.query.until
        query.timscope = "custom:#{req.query.since}:#{req.query.until}"
      if req.query.region
        query.region = "custom:#{req.query.region}"

      getPagePromise url, query, cookies
      .then (page) ->
        return throw new Error "ooops, no content!" if !page or !page.text
        ParseFeeds page.text

  Promise.all getPagePromises
  .then (result) ->
    res.send result
  .catch next