fs = require 'fs'

config = require 'config'
Promise = require 'bluebird'
_ = require 'underscore'

redis = require('redis').createClient config.redis.port, config.redis.host
cookieFile = "#{__basename}/media/weibo/login/cookies.txt"

Cookies = module.exports = 

  getCookies: ->
    redis.getAsync "media:weibo_cookies"
    .then (result) ->
      unless result
        fs.readFileAsync cookieFile, encoding: "utf-8"
      else
        result
    .then (result) ->
      return [] unless result
      JSON.parse result

  getCookieStr: ->
    Cookies.getCookies()
    .then (result) ->
      validCookies = _.reject result, (cookie) ->
        return !_.findWhere cookie.cookie, name: 'un'
      randomIndex = Math.floor(Math.random() * validCookies.length)
      cookies = validCookies[randomIndex]?.cookie
      cookieStr = ''
      _.forEach cookies, (v, i) ->
        cookieStr += "#{v.name}=#{v.value};"
      cookieStr
