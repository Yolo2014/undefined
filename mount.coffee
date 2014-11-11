module.exports = (app) ->

  app.use '/media', require './media/'

  app.use '/joke', require './modules/joke'