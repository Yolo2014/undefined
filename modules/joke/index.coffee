express = require 'express'

module.exports = app = express()

app.route '/feeds'
  .get require './feeds'