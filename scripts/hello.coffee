module.exports = (robot) ->
  robot.hear /Hello/i, (res) ->
    res.send "Hello World!"