fs = require 'fs'

_ = require 'underscore'
moment = require 'moment'
cheerio = require 'cheerio'

module.exports = (page) ->

  $ = cheerio.load page,
    decodeEntities: false

  feeds = _.map $('.main-area'), (feed) ->
    $feed = $(feed)
    title = $feed.find('.main-title').text().split(' ')
    content = $feed.find('.main-content p').text()
    image = $feed.find('.main-content p').last().find('img').attr('src')
    feed =
      title: title[1]
      content: content
      image: image
    feed
  feeds
