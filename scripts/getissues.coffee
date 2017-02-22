# from http://blog.spacemarket.com/code/hubot-github-webhook-1/
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

switch action
when 'opened'
"#{pr.user.login}さんからPull Requestをもらいました #{pr.title} #{pr.html_url}"
when 'closed'
if pr.merged
"#{pr.user.login}さんのPull Requestをマージしました #{pr.title} #{pr.html_url}"

tweetForIssues = (json) -&gt;
action = json.action
issue = json.issue

switch action
when 'opened'
"#{issue.user.login}さんがIssueを上げました #{issue.title} #{issue.html_url}"
when 'closed'
"#{issue.user.login}さんのIssueがcloseされました #{issue.title} #{issue.html_url}"