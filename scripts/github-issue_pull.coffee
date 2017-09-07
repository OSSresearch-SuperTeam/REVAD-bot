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
  request = require("request")
  github = require("githubot")(robot)
  robot.respond /repo (issue|pull)s (.*)$/i, (msg) ->
    data_name = msg.match[1]
    read_github msg, "#{data_name}s?state=all", (issues) ->
      members = Array.from(issues.map(getUser)).length
      max_length = issues.length
      open_issues = issues.filter(isOpen)
      msg.send "合計:#{max_length} 未解決:#{open_issues.length}"
      for issue in open_issues
        if issue.assignee
          msg.send "担当:#{issue.assignee.login} タイトル:#{issue.title} 投稿者:#{issue.user.login}"
        else
          msg.send "担当:なし タイトル:#{issue.title} 投稿者:#{issue.user.login}"

  robot.respond /repo no-comment-(issue|pull)s (.*)$/i, (msg) ->
    data_name = msg.match[1]
    read_github msg, "#{data_name}s?comments=0", (issues) ->
      issues = issues.filter(isLong)
      max_length = issues.length
      msg.send "#{max_length}個の#{data_name}がコメントされていません"
      for issue in issues
        msg.send "タイトル:#{issue.title} 投稿日:#{issue.created_at} 投稿者:#{issue.user.login}"


  robot.respond /repo no-assign-(issue|pull)s (.*)$/i, (msg) ->
    data_name = msg.match[1]
    read_github msg, "#{data_name}s", (issues) ->
      issues = issues.filter(noAssign)
      max_length = issues.length
      msg.send "#{max_length}個の#{data_name}sがassignされていません"
      for issue in issues
        msg.send "タイトル:#{issue.title} 投稿日:#{issue.created_at}投稿者:#{issue.user.login}"

  robot.respond /repo no-reaction-(issue|pull)s (.*)$/i, (msg) ->
    data_name = msg.match[1]
    read_github msg, "#{data_name}s", (issues) ->
      issues = issues.filter(noReaction)
      max_length = issues.length
      msg.send "#{max_length}個の#{data_name}sがリアクションされていません"
      for issue in issues
        msg.send "タイトル:#{issue.title} 投稿日:#{issue.created_at}投稿者:#{issue.user.login}"

  read_github = (msg, tails, response_handler) ->
    repo = github.qualified_repo msg.match[2]
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
  getUser = (data) -> data.user.login
  noAssign = (data) -> data.assignees.length == 0
  noReaction = (data) -> data.created_at == data.updated_at
  pollmsg = (msg) ->  "`"+ msg + "` :+1: :-1: :ok_hand: :confused: :bug:"
