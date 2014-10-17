require('coffee-script/register');

var fs = require('fs');
var path;

global.__basename = __dirname;

process.env.TZ = "PRC";

process.env.NODE_CONFIG_DIR = __dirname + '/config';

if(!process.env.NODE_ENV) {
  if(fs.existsSync(path = __basename + "/config/env.coffee")) {
    process.env.NODE_ENV = require(path);
  } else {
    process.env.NODE_ENV = 'development';
  }
}

var config = require('config');
process.env.DEBUG = process.env.DEBUG || config.debug;

require('./_promisify');

require('./crons/weibo')()