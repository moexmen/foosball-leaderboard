class PlayerMatch < ActiveRecord::Base
  def after_create
    # Update score for individual player
    match = Match.find(self.match_id)
    score = Score.where(player_id: self.player_id).take!

    # update wins and loses for scoreboard
    (match.winner == team) ? score.wins += 1 : score.loses += 1

    # update goals for scoreboard
    (team == 'r') ? score.goals += match.redGoal : score.goals += match.blueGoal

    # save scoreboard
    score.save

    puts "[SERVER] Updated scoreboard of player #{self.player_id}"
  end

end
