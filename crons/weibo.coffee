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































  # request
  # .get 'http://192.168.5.30:7006/segment'
  # .set
  #   "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
  #   "Accept-Encoding": "gzip,deflate,sdch"
  #   "Accept-Language": "zh-CN,zh;q=0.8,zh-TW;q=0.6,en;q=0.4"
  #   "Cache-Control": "max-age=0"
  #   "Connection": "keep-alive"
  #   "Host": "192.168.5.30:7006"
  #   "User-Agent": "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"
  # .query
  #   method: 'to'
  #   input: '你真是一个好人'
  #   nature: true
  # .end (err, res) ->
  #   return console.log err if err
  #   console.log res.body