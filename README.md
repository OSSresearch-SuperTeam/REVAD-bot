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

### github-issue_pulls.coffee
プルリクエストとissueの情報を出力

`revad-bot repo pulls <repo>`
または
`revad-bot repo issues <repo>`
放置されたissueを見つけるときは
`revad-bot repo long-issues <repo>`

## github-activity.coffee
最近のプロジェクトの変更を取得する
`revad-bot repo show <repo>`

## spacenotifire.coffee
リポジトリ上でのやり取りを通知する
作りかけ

## 利用方法
`<repo>`はリポジトリオーナー名/リポジトリ名(e.g.Ikuyadeu/REVAD-bot)
### GHE管理者向け機能
GHE全体での情報を取得
* `hubot ghe license` - ライセンス情報
* `hubot ghe stats issues` - issue情報
* `hubot ghe stats milestones` - マイルストーン情報
* `hubot ghe stats orgs` - オーガナイゼーション情報
* `hubot ghe stats comments` - コメント情報
* `hubot ghe stats pages` - ページ数情報
* `hubot ghe stats users` - 管理者数情報
* `hubot ghe stats gists` - Gist情報
* `hubot ghe stats pulls` - Pull情報
* `hubot ghe stats repos` - リポジトリ情報

### プロジェクト管理者向け機能
* `hubot repo show <repo>` - 最近のリポジトリのアクティビティの取得
* `hubot repo issues <repo>` - リポジトリ内のissueの取得
* `hubot repo pulls <repo>` - リポジトリ内のpullの取得
* `hubot repo long-issues <repo>` - リポジトリ内のコメントのついていないissueの取得
* `hubot repo commiters <repo>` - リポジトリ内のコミッターの取得
* `hubot repo top-commiters <repo>` - もっとも活躍しているコミッターの取得

### 開発者向け通知機能
* Issue,Pull
    * open
    * close
    * ラベル付け
    * ラベル外し
    * アサイン付け
    * アサイン外し
    * マージ(Pull Requestのみ)

## 評価方法
* :+1: いいね
* :-1: わるいね
* :ok_hand: まずまず
* :confused: 意味がわからない
* :bug: バグ

## 拡張のためのアイディア
* Probotのapps->OAuthへの対応
* Matter Mostのコマンド呼び出しへの対応
* GitHub Enterpriseのappsへの対応

## 貢献者タイプ
* Issue reporter
* Issue responder
* Code contributor
* Documentation contributor
* Reviewer
* Maintainer
* Connector

具体的なフィードバック、アイディアがあればemail(ikuyadeu0513@gmail.com)へ