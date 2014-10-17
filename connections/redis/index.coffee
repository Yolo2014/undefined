redis = require 'redis'
config = require 'config'
moment = require 'moment'

exports = module.exports = client = redis.createClient config.redis.port, config.redis.host

client.on 'error', (err) ->
  console.error ''
  console.error "[ERROR] #{moment().format('YYYY-MM-DD HH:mm:ss')} Handled error"
  console.error err.stack
