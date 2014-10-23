fs = require 'fs'

_ = require 'underscore'
moment = require 'moment'
cheerio = require 'cheerio'

module.exports = (page) ->
  retval = {}

  patterns =
    implicitloginUser: /\$CONFIG\[\'nick\'\] = \'(.*?)\'/ ## 当前cookie用户名
    script: /<script>STK && STK.pageletM && STK.pageletM.view\(({"pid":"pl_weibo_direct".+)\)<\/script>/ ## 含有feed的部分
    totalCount: /<div class="search_num"><span>.+\\u5230(\d+).+?<\/span/ ## 结果总数

  ## metadata.loginUsers 目前cookie的身份
  retval.loginUser = page?.match(patterns.loginUser)?[1]

  feedBlock = page?.match patterns.script
  html = JSON.parse(feedBlock[1])?.html

  $ = cheerio.load html,
    decodeEntities: false

  feeds = _.map $('dl.feed_list'), (feed) ->
    $feed = $(feed)
    ## user
    $avatar = $feed.find("dt.face a")
    username = $feed.find('a[nick-name]')?.first().text()?.trim()
    user =
      id: $avatar?.attr("suda-data")?.match(/:(\d+)/)?[1]
      screen_name: username
      name: username
      profile_image_url: $avatar.find("img").attr("src")
    domain = $avatar.attr "href"
    user.domain = domain.substr(domain.lastIndexOf("/") + 1)
    ## counts
    $info = $feed.find("p.info")
    $time = $info?.find("a.date")
    $counts = $info?.find("span a")
    ## pics
    $pics = $feed.find(".list_pic_list ul, ul.piclist")?.children()
    pics = []
    _.each $pics, (pic) ->
      $pic = $(pic)
      urlSegments = $pic?.find("img")?.attr("src")?.split("/")
      cdn = urlSegments?[2]?.split(".")?[0] ## ww1 or ww2?
      img = _.last urlSegments
      baseUrl = "http://#{cdn}.sinaimg.cn"
      pics.push
        thumbnail_pic: "#{baseUrl}/thumbnail/#{img}"
        bmiddle_pic: "#{baseUrl}/bmiddle/#{img}"
        original_pic: "#{baseUrl}/large/#{img}"
    ## retweeted status
    $rt = $feed.find(".comment.W_textc")
    if $rt.length
      name = $rt.find('a[nick-name]').text()
      $rt_info = $rt.find("dd.info")
      $rt_time = $rt.find("a.date")
      urlArr = $rt_time?.attr("href")?.split("/") # http://weibo.com/1236589902/Bezff2dqm
      $rtCounts = $rt_info.find("span a")
      retweeted_status =
        id: urlArr[urlArr?.length - 1]
        text: $rt.find("em").last().html()
        created_at: moment(parseInt($rt_time.attr("date"))).toString()
        reposts_count: $rtCounts?.eq(0)?.text()?.match(/\d+/)?[0] or 0
        comments_count: $rtCounts?.eq(1)?.text()?.match(/\d+/)?[0] or 0
        user:
          id: urlArr[urlArr?.length - 2]
          name: name
          screen_name: name

    result =
      id: $feed.attr("mid")
      mid: _.last $time?.attr("href")?.split("/")
      user: user
      text: $feed.find('p[node-type=feed_list_content]>em').html()
      created_at: moment(parseInt($time?.attr("date"))).toString()
      source: $time?.next("a")?.html()
      attitudes_count: +$counts.first()?.text()?.match(/\d+/)?[0] or 0
      reposts_count: +$counts.eq(1)?.text()?.match(/\d+/)?[0] or 0
      comments_count: +$counts.eq(3)?.text()?.match(/\d+/)?[0] or 0

    if retweeted_status
      result.retweeted_status = retweeted_status
    if pics.length
      if result.retweeted_status
        feed = result.retweeted_status
      else
        feed = result
      feed.pic_urls = pics
      feed.thumbnail_pic = pics[0]?.thumbnail_pic
      feed.bmiddle_pic = pics[0]?.bmiddle_pic
      feed.original_pic = pics[0]?.original_pic

    return result

  retval.totalCount = page.match(patterns.totalCount)?[1]
  retval.feeds = feeds
  retval
