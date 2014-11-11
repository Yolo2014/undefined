mongoose = require 'mongoose'
moment = require 'moment'

module.exports = (settings) ->
  connection = mongoose.createConnection "mongodb://#{settings.host}: #{settings.port}/#{settings.database}",
    server:
      poolSize: settings.poolSize or 5
      keepAlive: 1
    user: settings.user
    pass: settings.pass

  connection.on 'error', (err) ->
    console.log ''
    console.log "[ERROR] #{moment().format('YYYY-MM-DD HH:mm:ss')} handled error"
    console.log err.stack

  connection