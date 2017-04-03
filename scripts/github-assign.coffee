# Description:
#   Get the pull request and assign
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#
# Commands:
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
  robot.respond /repo pulls (.*)$/i, (msg) ->
    read_pulls msg, (pulls) ->
      max_length = pulls.length
      max_length = 20 if pulls.length > 20
      for pull in pulls
        if pull.assignee
          msg.send "assignee:#{pull.assignee.login} title:#{pull.title}"
          max_length -= 1
        return unless max_length

  robot.respond /who assign (.*)\s(.*)$/i, (msg) ->
    read_pull msg, (pull) ->
      if pull.assignee
        msg.send "#{pull.assignee.login} is assignee in \##{pull.title}"
      else
        read_contributors msg, (cont) ->
          contributor = msg.random cont
          msg.send "#{contributor.login} is best assignee in \##{pull.title}"

    return msg

  read_pull = (msg, response_handler) ->
    repo = github.qualified_repo msg.match[1]
    number = msg.match[2]
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    url = "#{base_url}/repos/#{repo}/pulls/#{number}"
    github.get url, (pulls) ->
      if pulls.message
        msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{pulls.message}!"
      else if pulls.length == 0
        msg.send "Achievement unlocked: [LIKE A BOSS] no pulls found!"
      else
        if process.env.HUBOT_GITHUB_API
          base_url = base_url.replace /\/api\/v3/, ''
        msg.send "#{base_url}/#{repo}"
        response_handler pulls

  read_pulls = (msg, response_handler) ->
    repo = github.qualified_repo msg.match[1]
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    url = "#{base_url}/repos/#{repo}/pulls?state=close"
    github.get url, (pulls) ->
      if pulls.message
        msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{pulls.message}!"
      else if pulls.length == 0
        msg.send "Achievement unlocked: [LIKE A BOSS] no pulls found!"
      else
        if process.env.HUBOT_GITHUB_API
          base_url = base_url.replace /\/api\/v3/, ''
        msg.send "#{base_url}/#{repo}"
        response_handler pulls

  read_contributors = (msg, response_handler) ->
    repo = github.qualified_repo msg.match[1]
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    url = "#{base_url}/repos/#{repo}/contributors"
    github.get url, (commits) ->
      if commits.message
        msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{commits.message}!"
      else if commits.length == 0
        msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
      else
        if process.env.HUBOT_GITHUB_API
          base_url = base_url.replace /\/api\/v3/, ''
        msg.send "#{base_url}/#{repo}"
        response_handler commits
