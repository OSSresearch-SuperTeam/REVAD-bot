# Description:
#   Access your GitHub Enterprise instance through Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GHE_URL
#   HUBOT_GHE_TOKEN
#
# Commands:
#   hubot ghe license - returns license information
#   hubot ghe stats issues - returns the number of open and closed issues
#   hubot ghe stats milestones - returns the number of open and closed milestones
#   hubot ghe stats orgs - returns the number of organizations, teams, team members, and disabled organizations
#   hubot ghe stats comments - returns the number of comments on issues, pull requests, commits, and gists
#   hubot ghe stats pages - returns the number of GitHub Pages sites
#   hubot ghe stats users - returns the number of suspended and admin users
#   hubot ghe stats gists - returns the number of private and public gists
#   hubot ghe stats pulls - returns the number of merged, mergeable, and unmergeable pull requests
#   hubot ghe stats repos - returns the number of organization-owned repositories, root repositories, forks, pushed commits, and wikis
#
# Authors:
#   pnsk, mgriffin

module.exports = (robot) ->
  url = process.env.HUBOT_GHE_URL + '/api/v3'
  token = process.env.HUBOT_GHE_TOKEN
  # If you're using a self signed certificate, uncomment the next line
  # process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

  unless token
    robot.logger.error "GitHub Enterprise token isn't set."

  robot.respond /ghe license$/i, (msg) ->
    ghe_license msg,token,url

  robot.respond /ghe stats (.*)$/i, (msg) ->
    ghe_stats msg,token,url

ghe_license = (msg, token, url) ->
  msg.http("#{url}/enterprise/settings/license")
  .header("Authorization", "token #{token}")
  .get() (err, res, body) ->
    if err
      msg.send "error"
    else
      if res.statusCode is 200
        results = JSON.parse body
        msg.send "GHE has #{results.seats} seats,
                  and #{results.seats_used} are used.
                  License expires at #{results.expire_at}."
      else
        msg.send "statusCode: #{res.statusCode}"

ghe_stats = (msg, token, url) ->
  type = msg.match[1]
  msg.http("#{url}/enterprise/stats/#{type}")
  .header("Authorization", "token #{token}")
  .get() (err, res, body) ->
    if err
      msg.send "error"
    else
      if res.statusCode is 200
        results = JSON.parse body
        switch type
          when "issues" then msg.send pollmsg """合計issue:#{results.total_issues},
                                       open:#{results.open_issues},
                                       close:#{results.closed_issues}."""
          when "milestones"
          then msg.send pollmsg """合計milestone:#{results.total_milestones},
                         open:#{results.open_milestones},
                         close:#{results.closed_milestones}."""
          when "orgs" then msg.send pollmsg """合計org数:#{results.total_orgs}
                                     利用不能:#{results.disabled_orgs}.\n
                                     チーム:#{results.total_teams}
                                     #{results.total_team_members}人."""
          when "comments"
          then msg.send pollmsg """コミットコメント:#{results.total_commit_comments}.\n
                         gistコメント:#{results.total_gist_comments}.\n
                         issueコメント#{results.total_issue_comments}.\n
                         PRコメント#{results.total_pull_request_comments}.\n"""
          when "pages" then msg.send pollmsg """ページ数:#{results.total_pages}ページ."""
          when "users" then msg.send pollmsg """ユーザー数:#{results.total_users}人,
                                      管理者:#{results.admin_users}人
                                      凍結:#{results.suspended_users}人."""
          when "gists" then msg.send pollmsg """gists数:#{results.total_gists},
                                      private:#{results.private_gists}
                                      public:#{results.public_gists}."""
          when "pulls" then msg.send pollmsg """pull数:#{results.total_pulls},
                                      merged:#{results.merged_pulls},
                                      merge可能:#{results.mergable_pulls}
                                      未merge#{results.unmergable_pulls}."""
          when "repos" then msg.send pollmsg """リポジトリ数:#{results.total_repos},
                                      ルートリポジトリ:#{results.root_repos}
                                      フォーク:#{results.fork_repos}.\n
                                      orgリポジトリ:#{results.org_repos}.\n
                                      プッシュ数:#{results.total_pushes}.\n
                                      wiki数:#{results.total_wikis}."""
      else
        msg.send """statusCode:
                  #{res.statusCode}
                  -- #{body}
                  -- type: #{type}
                  -- #{msg.match[1]}"""
  
  pollmsg = (msg) ->  "\\poll `"+ msg + "` :+1: :-1: :ok_hand: :confused: :bug:"
