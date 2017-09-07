# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot usage <repo> - shows help for github function
#
# Author:
#   ikuyadeu
module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond /usage$/i, (msg) ->
    msg.send """
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

    具体的なフィードバック、アイディアがあればemail(ikuyadeu0513@gmail.com)へ

                    """


  pollmsg = (msg) ->  "\\poll `"+ msg + "` :+1: :-1: :ok_hand: :confused: :bug:"