{CronJob} = require 'cron'
config = require 'config'
exec = require('child_process').exec


module.exports = ->
  new CronJob
    cronTime: config.cron.weibo.time
    start: config.cron.weibo.active
    onTick: onTick
    
onTick = ->
  console.log 'cookies'
  exec "phantomjs #{__basename}/media/weibo/login/login.js > #{__basename}/media/weibo/login/login.log", (error, stdout, stderr) ->
    console.log "stdout: " + stdout
    console.log "stderr: " + stderr
    if error isnt null
      console.log "exec error: " + error
