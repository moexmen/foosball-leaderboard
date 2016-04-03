class PlayerMatch < ActiveRecord::Base
  after_create 'update_player_score'
  after_update 'update_player_score'

  def update_player_score
    # Update score for individual player
    match = Match.find(self.match_id)
    score = Score.where(player_id: self.player_id).take!

    puts 'ADDING MATCH'
    puts 'SCORE ID: ' + score.id.to_s
    puts 'WINS: ' + score.wins.to_s
    puts 'LOSES: ' + score.loses.to_s
    puts 'POINTS: ' + score.points.to_s
    puts 'GOALS: ' + score.goals.to_s
    puts 'PULLUPS' + score.pullUps.to_s
    puts 'WRATIO' + score.wRatio.to_s

    # update wins and points
    (match.winner == team) ? score.wins += 1 : score.loses += 1
    (match.winner == team) ? score.points += 3 : score.points += 1

    # update goals
    (team == 'r') ? score.goals += match.redGoal : score.goals += match.blueGoal

    # update pullUps
    no_pull_up = (match.winner == 'r') ? match.redGoal - match.blueGoal : match.blueGoal - match.redGoal
    score.pullUps += no_pull_up if match.winner != team

    # update wRatio
    new_win_ratio = score.wins.fdiv(score.wins + score.loses)
    score.wRatio = sprintf '.10f', new_win_ratio

    # save scoreboard
    score.save

    puts 'AFTER ADDING MATCH MATCH'
    puts 'SCORE ID: ' + score.id.to_s
    puts 'WINS: ' + score.wins.to_s
    puts 'LOSES: ' + score.loses.to_s
    puts 'POINTS: ' + score.points.to_s
    puts 'GOALS: ' + score.goals.to_s
    puts 'PULLUPS' + score.pullUps.to_s
    puts 'WRATIO' + score.wRatio.to_s

    puts "[SERVER] Updated scoreboard of player #{self.player_id}"
  end

end
