express = require 'express'

cookies = require './weibo/cookies'

module.exports = app = express()

app.route '/weibo/feeds'
  .get require './weibo/feeds'