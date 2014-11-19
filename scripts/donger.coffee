# Description:
#   A way to get dongers from dongerlist
#
# Commands:
#   hubot donger me - Gets a random donger from the first page
#   hubot donger me <query> - Gets a random donger from the <query> tag page

select = require('soupselect').select
htmlparser = require("htmlparser")

module.exports = (robot) ->
  robot.respond /donger( me)? (.*)/i, (msg) ->
    msg.http(dongerlistUrl(msg.match[2])).header('User-Agent', '').get() (err, res, body) ->
      handler = new htmlparser.DefaultHandler (err, dom) ->
        msg.send randomDonger(dom)

      new htmlparser.Parser(handler).parseComplete(body);

randomDonger = (dom) ->
  dongers = select(dom, '.copy-donger')
  if dongers.length == 0
    'NO DONGERS FOR YOU ᕙ(ಠ▃ಠ )'
  else
    dongers[Math.floor(Math.random() * dongers.length)].attribs['data-clipboard-text']

dongerlistUrl = (query) ->
  url = "http://dongerlist.com"
  url += "/category/#{query}" if query != 'me'
  url
