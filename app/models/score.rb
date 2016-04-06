class Score < ActiveRecord::Base
  belongs_to :player
  def self.remove_match(match_id, player_match)
    match = Match.find(match_id)

    if Score.exists?(player_id: player_match.player_id)
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
      score.wRatio = sprintf('%.10f', new_win_ratio)

      score.save
      puts "[SERVER] Removed match #{match.id} from player #{player_match.player_id}'s scoreboard"
    end
  end

  def self.update_player_score(match_id, player_match)
    # Update score for individual player
    match = Match.find(match_id)
    if Score.exists?(player_id: player_match.player_id)
      score = Score.where(player_id: player_match.player_id).take!
      # update wins and points
      (match.winner == player_match.team) ? score.wins += 1 : score.loses += 1
      (match.winner == player_match.team) ? score.points += 3 : score.points += 1

      # update goals
      (player_match.team == 'r') ? score.goals += match.redGoal : score.goals += match.blueGoal

      # update pullUps
      no_pull_up = (match.winner == 'r') ? match.redGoal - match.blueGoal : match.blueGoal - match.redGoal
      score.pullUps += no_pull_up if match.winner != player_match.team

      # update wRatio
      new_win_ratio = score.wins.fdiv(score.wins + score.loses)
      score.wRatio = sprintf('%.10f', new_win_ratio)

      # save scoreboard
      score.save
      puts "[SERVER] Updated scoreboard of player #{player_match.player_id}"
    end
  end

  def self.get_score_info(player_id)
    score = Score.where(:player_id => player_id).take!
    return score
  end
end
