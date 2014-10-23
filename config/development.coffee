module.exports = 

  debug: 'api:*'

  web:
    port: '6116'
    baseUrl: 'http://192.168.5.30:6116'

  api:
    host: ''

  session:
    secret: 'whatthefuckisthis'

  db:
    mysql:
      weibo:
        host: 'localhost'
        port: '3306'
        user: 'fengtian'
        password: 'fengtian'
        database: 'epop'
        activte: true
    mongo:
      weibo:
        host: 'localhost'
        port: '27017'
        database: 'express'
        user: 'fengtian'
        password: 'fengtian'

  redis:
    host: 'localhost'
    port: 6379

  cron:
    weibo:
      active: true
      time: '00 10 */2 * * *'
