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
#   Ikuyadeu
# coffeelint: disable=max_line_length

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond /repo issues (.*)$/i, (msg) ->
    read_github msg, "issues?state=all", (issues) ->
      max_length = issues.length
      open_issues = issues.filter(isOpen)
      msg.send pollmsg "合計:#{max_length}\n未解決:#{open_issues.length}"
      for issue in open_issues
        if issue.assignee
          msg.send "担当:#{issue.assignee.login} タイトル:#{issue.title}"

  robot.respond /repo pulls (.*)$/i, (msg) ->
    read_github msg, "pulls?state=all", (pulls) ->
      max_length = pulls.length
      open_pulls = pulls.filter(isOpen)
      msg.send pollmsg "合計:#{max_length}\n未解決:#{open_pulls.length}"
      for pull in open_pulls
        if pull.assignee
          msg.send "担当:#{pull.assignee.login} タイトル:#{pull.title}"

  robot.respond /repo long-issues (.*)$/i, (msg) ->
    read_github msg, "issues?comments=0", (issues) ->
      issues = issues.filter(isLong)
      max_length = issues.length
      msg.send "#{max_length}個のissueが放置されています"
      for issue in issues
        msg.send "タイトル:#{issue.title}\n投稿日:#{issue.created_at}投稿者:#{issue.user.login}"

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
  isLong = (data) -> data.comments == 0
  pollmsg = (msg) ->  "\\poll `"+ msg + "` :+1: :-1: :bug:"