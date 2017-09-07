# Description:
# GitHub Webhookのエンドポイント
#
# Notes:
# Pull Request, Issueが対象
crypto = require 'crypto'

module.exports = (robot) -&gt;
robot.router.post "/github/webhook", (req, res) -&gt;
event_type = req.get 'X-Github-Event'
signature = req.get 'X-Hub-Signature'

unless isCorrectSignature signature, req.body
res.status(401).send 'unauthorized'
return

tweet = switch event_type
when 'issues'
tweetForIssues req.body
when 'pull_request'
tweetForPullRequest req.body

if tweet?
robot.send {}, tweet
res.status(201).send 'created'
else
res.status(200).send 'ok'

isCorrectSignature = (signature, body) -&gt;
pairs = signature.split '='
digest_method = pairs[0]
hmac = crypto.createHmac digest_method, process.env.HUBOT_GITHUB_SECRET
hmac.update JSON.stringify(body), 'utf-8'
hashed_data = hmac.digest 'hex'
generated_signature = [digest_method, hashed_data].join '='

return signature is generated_signature

tweetForPullRequest = (json) -&gt;
action = json.action
pr = json.pull_request
sender = json.sender

switch action
when 'opened'
    msg += "#{pr.user.login}さんからPull Requestをもらいました #{pr.title} #{pr.html_url}"
when 'closed'
    if pr.merged
        msg += "#{sender.login}さんがPull Requestをマージしました #{pr.title} #{pr.html_url}"
    else
        msg += "#{sender.login}さんがPull Requestをクローズしました #{pr.title} #{pr.html_url}"
when "labeled"
    msg += " #{sender.login}さんが\"#{json.label.name}\"に分類しました#{pr.title} #{pr.html_url}"
when "unlabeled"
    msg += " #{sender.login}さんが分類\"#{json.label.name}\"を取り除きました#{pr.title} #{pr.html_url}"
when "assigned"
    msg += "#{json.assignee.login}さんが#{sender.login}さんにアサインされました"
when "unassigned"
    msg += "#{json.assignee.login}さんが#{sender.login}さんにアサインを外されました"

tweetForIssues = (json) -&gt;
action = json.action
issue = json.issue
sender = json.sender

switch action
when 'opened'
    msg += "#{issue.user.login}さんがIssueを上げました #{issue.title} #{issue.html_url}"
when 'closed'
    msg += "#{sender.login}さんがIssueがcloseされました #{issue.title} #{issue.html_url}"
else
    msg += "#{sender.login}さんがIssuetをクローズしました #{pr.title} #{pr.html_url}"
when "labeled"
    msg += " #{sender.login}さんが\"#{json.label.name}\"に分類しました#{issue.title} #{issue.html_url}"
when "unlabeled"
    msg += " #{sender.login}さんが分類\"#{json.label.name}\"を取り除きました#{issue.title} #{issue.html_url}"
when "assigned"
    msg += "#{json.assignee.login}さんが#{sender.login}さんにアサインされました#{issue.title} #{issue.html_url}"
when "unassigned"
    msg += "#{json.assignee.login}さんが#{sender.login}さんにアサインを外されました#{issue.title} #{issue.html_url}"