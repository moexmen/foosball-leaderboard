class Score < ActiveRecord::Base
  def self.remove_match(match_id, player_match)
    match = Match.find(match_id)
    score = Score.where(:player_id => player_match.player_id).take!

    # remove wins, loses and points
    (match.winner == player_match.team) ? score.wins -= 1 : score.loses -= 1
    (match.winner == player_match.team) ? score.points -= 3 : score.points -= 1

    # remove goals
    (player_match.team == 'r') ? score.goals -= match.redGoal : score.goals -= match.blueGoal

    # remove pullUps
    no_pull_up = (match.winner == 'r') ? match.redGoal - match.blueGoal : match.blueGoal - match.redGoal
    score.pullUps -= no_pull_up if match.winner != player_match.team

    # update wRatio
    new_win_ratio = score.wins.fdiv(score.wins + score.loses)
    score.wRatio = sprintf '.10f', new_win_ratio

    puts 'REMOVE MATCH'
    puts 'SCORE ID: ' + score.id.to_s
    puts 'WINS: ' + score.wins.to_s
    puts 'LOSES: ' + score.loses.to_s
    puts 'POINTS: ' + score.points.to_s
    puts 'GOALS: ' + score.goals.to_s
    puts 'PULLUPS: ' + score.pullUps.to_s
    puts 'WRATIO: ' + score.wRatio.to_s

    score.save
    puts "[SERVER] Removed match #{match.id} from player #{player_match.player_id}'s scoreboard"
  end

end
