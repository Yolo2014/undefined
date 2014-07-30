
express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
  res.render 'index',
    title: 'Hello, Express with coffee!'

module.exports = router