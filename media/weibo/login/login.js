var accounts = require('./accounts.js'),
    page = require('webpage').create(),
    fs = require('fs'),
    debugInfo = "",
    cookies = [];

page.customHeaders = {
  "Connection": "keep-alive",
  "Cache-Control": "max-age=0",
  "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
  "Accept-Language": "zh-CN,zh;q=0.8,en-GB;q=0.6,en;q=0.4",
  "User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.107 Safari/537.36"
};

page.onUrlChanged = function (url) {
  console.log("[URL]:" + url);
}

page.onError = function(msg, trace) {
  var msgStack = ['[ERROR]' + msg];
  if(trace && trace.length) {
    msgStack.push('TRACE:');
    trace.forEach(function(t) {
      msgStack.push('->' + t.file + ': ' + t.line + (t.function ? '(in function "' + t.function + '")' : ''));
    });
  }
  console.error(msgStack.join("\n"));
}

page.onResourceRequested = function(request) {
  debugInfo += "[REQUEST]" + request.url + "\n";
}

page.onConsoleMessage = function(msg, lineNum, sourceId) {
  debugInfo += "[CONSOLE]" + msg + " from line #" + lineNum + ' in "' + sourceId + '")' + "\n";
}

page.settings.userAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.107 Safari/537.36";

var accountIndex = 0;

openLoginPage();

function openLoginPage() {
  setTimeout(function() {
    page.open("http://weibo.com/login.php", function(stat) {
      console.log("Status:" + stat);
      if(stat == 'fail') {
        return openLoginPage();
      }
      fillForm();
    })
  }, 2000);
}

function fillForm() {
  console.log("Fill Form");
  var account = accounts[accountIndex].account,
      password = accounts[accountIndex].password;
  console.log("Using account: " + account);

  //enter username
  page.evaluate(function() {
    document.getElementsByClassName("username")[0].getElementsByTagName("input")[0].focus();
  })
  page.sendEvent('keypress', account);
  page.sendEvent('keypress', page.event.key.Enter);

  //enter password
  page.evaluate(function() {
    document.getElementsByClassName("password")[0].getElementsByTagName("input")[0].focus();
  })
  page.sendEvent('keypress', password);
  page.sendEvent('keypress', page.event.key.Enter);

  //waiting for login
  setTimeout(function() {
    fs.write('./media/weibo/login/logs/result_page_' + account + '.html', page.content, 'w');
    //waiting for write
    console.log("Waiting for write for 5 sec...");
    function nextAccount(){
      cookies[account] = page.cookies;
      cookies.push({
        id: account,
        cookie: page.cookies
      })
      if(accounts[++accountIndex]) {
        console.log("next account: " + accountIndex);
        page.clearCookies();
        phantom.clearCookies();
        openLoginPage();
      }
      else {
        console.log("no more account, exit");
        fs.write('./media/weibo/login/cookies.txt', JSON.stringify(cookies), 'w');
        fs.write('./media/weibo/login/logs/debug.log', debugInfo);
        setTimeout(phantom.exit, 1000);
      }
    }
    setTimeout(nextAccount, 5000);
  }, 20000)
}