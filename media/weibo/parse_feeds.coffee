fs = require 'fs'

_ = require 'underscore'
moment = require 'moment'
cheerio = require 'cheerio'

module.exports = (page) ->
  retval = {}

  patterns =
    loginUser: /\$CONFIG\[\'nick\'\] = \'(.*?)\'/ ## 当前cookie用户名
    script: /<script>STK && STK.pageletM && STK.pageletM.view\(({"pid":"pl_weibo_direct".+)\)<\/script>/ ## 含有feed的部分
    totalCount: /<div class="search_num"><span>.+\\u5230(\d+).+?<\/span/ ## 结果总数

  ## metadata.loginUsers 目前cookie的身份
  retval.loginUser = page?.match(patterns.loginUser)?[1]

  feedBlock = page?.match patterns.script
  html = JSON.parse(feedBlock[1])?.html

  $ = cheerio.load html

  feeds = _.map $('dl.feed_list'), (feed) ->
    $feed = $(feed)

    $avatar = $feed.find 'dt.face a'