Promise = require 'bluebird'

Promise.promisifyAll require 'fs'
Promise.promisifyAll require 'child_process'
Promise.promisifyAll require 'mongoose'
Promise.promisifyAll require 'superagent'
