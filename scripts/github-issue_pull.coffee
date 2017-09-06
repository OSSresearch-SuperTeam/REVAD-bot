# Description:
#   Show the commiters from a repo
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#
# Commands:
#   hubot repo issues <repo> - shows issues of repository
#   hubot repo pulls <repo> - shows pulls of repository
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path
#   (for Github enterprise users)
#
# Author:
#   vquaiato
# coffeelint: disable=max_line_length

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond /repo issues (.*)$/i, (msg) ->
    read_github msg, "issues?state=all", (issues) ->
      max_length = issues.length
      open_issue = issues.filter(isOpen)
      msg.send pollmsg "合計:#{max_length}\n未解決:#{open_issue.length}"

  robot.respond /repo pulls (.*)$/i, (msg) ->
    read_github msg, "pulls?state=all", (pulls) ->
      max_length = pulls.length
      open_pull = pulls.filter(isOpen)
      msg.send pollmsg "合計:#{max_length}\n未解決:#{open_pull.length}"

  read_github = (msg, tails, response_handler) ->
    repo = github.qualified_repo msg.match[1]
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    url = "#{base_url}/repos/#{repo}/#{tails}"
    github.get url, (datas) ->
      if datas.length == 0
        msg.send pollmsg "Achievement unlocked: [LIKE A BOSS] no datas found!"
      else
        if process.env.HUBOT_GITHUB_API
          base_url = base_url.replace /\/api\/v3/, ''
        msg.send "#{base_url}/#{repo}"
        response_handler datas
  isOpen = (data) -> data.state == "open"
  pollmsg = (msg) ->  "\\poll `"+ msg + "` :+1: :-1: :bug:"