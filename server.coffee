epxress = require 'express'
http = require 'http'
config = require 'config'
moment = require 'moment'
cookieParser = require 'cookie-parser'
cookieSession = require 'cookie-session'
bodyParser = require 'body-parser'

app = express()

module.exports = server = http.createServer app

app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'
app.engine 'hbs', engines.handlebars

app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'
app.engine 'hbs', engines.handlebars

app.use bodyParser limit: '5mb'
app.use cookieParser()
app.use cookieSession secret: config.session.secret

require('./mount')(app)
app.use stylus
app.use '/public', express.static __dirname + '/public'

app.use (err, req, res, next) ->
  console.error ''
  console.error "[ERROR] #{moment().format('YYYY-MM-DD HH:mm:ss')} Handled error"
  console.error err.stack
  res.send 500, error: err.message