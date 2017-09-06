# revad-bot
個々のプロジェクトファイルが独立したプロジェクトでのレビュー推進用bot

## 必要なもの
### GitHubアカウント
setting -> Integrationsからトークンを生成する。

### Slack
App DirectoryからHubotをインストールしトークンを生成する。

## 実行前に設定する変数
Windowsなら`$ set ~~=xx`,
Mac,Linuxは`$ export ~~=xx`で設定、
HerokuならSetting->Reveal Config Varsから

* `HUBOT_ADAPTER=slack`, 
* `HUBOT_SLACK_TOKEN=Slackで生成したトークン`, 
* `HUBOT_SLACK_TEAM=参加させるSlackのチーム名`, 
* `HUBOT_SLACK_BOTNAME=revad-bot`, 
* `HUBOT_GITHUB_TOKEN=GitHubのトークン`, 

## 実行方法
`$ ./bin/hubot`

## scripts/内構成
### exapmle.coffee
初期のサンプルコード

### hello.coffee
動作テスト用：Helloと送ると"Hello World!"と返す

### github-commiters.coffee
https://github.com/github/hubot-scripts/blob/master/src/scripts/github-commiters.coffee
から利用。

`revad-bot repo commiters <repo>`

と送るとコミッター情報を返す。
`<repo>`はリポジトリ名(例：OSSresearch-SuperTeam/REVAD-bot)

`revad-bot repo top-commiters <repo>`
と送るともっとも投稿を行っているコミッターを返す

### github-pulls.coffee
プルリクエストのアサインされた開発者を表示(closeされたもののみ)

`revad-bot repo pulls <repo>`
